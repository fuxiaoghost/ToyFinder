//
//  TBHttRequestUtil.m
//  ToyFinder
//
//  Created by Dawn on 13-5-30.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "TBHttRequest.h"
#import "CacheManager.h"
#import "JSON.h"

static NSMutableArray *sharedQueue = nil;

@interface TBHttRequest()
@property (nonatomic,copy) NSString *requestUrl;
@property (nonatomic,copy) NSString *sessionKey;
@end

@implementation TBHttRequest
@synthesize requestUrl;
@synthesize delegate;
@synthesize sessionKey;

- (void) dealloc{
    self.requestUrl = nil;
    self.sessionKey = nil;
    [params release];
    [super dealloc];
}

+ (void)initialize{
    if (self == [TBHttRequest class]) {
        sharedQueue = [[NSMutableArray alloc] initWithCapacity:4];
    }
}

+ (id) lastRequest{
    if (sharedQueue.count>0) {
        return [sharedQueue lastObject];
    }
    return nil;
}


#pragma mark -
#pragma mark 初始化方法
- (id) initWithParams:(NSDictionary *)paramsDict{
    if (self = [super init]) {
        if (paramsDict) {
            params = [[NSMutableDictionary alloc] initWithDictionary:paramsDict];
        }else{
            params = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
    }
    return self;
}

#pragma mark -
#pragma mark Public Method
+ (id) requestWithParams:(NSDictionary *)paramsDict{
    return [[[self alloc] initWithParams:paramsDict] autorelease];
}

- (void) startGetRequest{
    [sharedQueue addObject:self];
    
    iosClient = [TopIOSClient getIOSClientByAppKey:APP_KEY];
    
    NSMutableString *keystr = [NSMutableString string];
    for (NSString *mkey in [params allKeys]) {
        [keystr appendFormat:@"%@:%@;",mkey,[params objectForKey:mkey]];
    }
    self.requestUrl = keystr;
    
    CacheManager *cacheManager = [CacheManager manager];
    NSString *data = [cacheManager cacheForKey:self.requestUrl];
    if (data) {
        if ([delegate respondsToSelector:@selector(requestFinished:withDict:)]) {
            [delegate requestFinished:self withDict:[data JSONValue]];
        }
    }else{
        self.sessionKey = [iosClient api:@"GET" params:params target:self cb:@selector(showApiResponse:) userId:NICK needMainThreadCallBack:true];
    }
}

- (void) cancelRequest{
    if (self.sessionKey) {
        [iosClient cancel:self.sessionKey];
    }
    if ([delegate respondsToSelector:@selector(requestFailed:)]) {
        [delegate requestFailed:self];
    }
    [sharedQueue removeObject:self];
}

-(void)showApiResponse:(id)data{
    
    if ([data isKindOfClass:[TopApiResponse class]]){
        TopApiResponse *response = (TopApiResponse *)data;
        if ([response content]){
            if ([delegate respondsToSelector:@selector(requestFinished:withDict:)]) {
                [delegate requestFinished:self withDict:[[response content] JSONValue]];
            }
            CacheManager *cacheManager = [CacheManager manager];
            [cacheManager cacheData:[response content] forKey:self.requestUrl];
        }
        else {
            NSLog(@"%@",[(NSError *)[response error] userInfo]);
            if ([delegate respondsToSelector:@selector(requestFailed:)]) {
                [delegate requestFailed:self];
            }
        }
    }
    self.sessionKey = nil;
    [sharedQueue removeObject:self];
}

@end
