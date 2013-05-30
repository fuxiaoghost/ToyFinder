//
//  TBHttRequestUtil.h
//  ToyFinder
//
//  Created by Dawn on 13-5-30.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBHttRequestDelegate;
@interface TBHttRequest : NSObject{
@private
    NSMutableDictionary *params;        // POST 参数
    TopIOSClient *iosClient;
    id delegate;
}
@property (nonatomic,assign) id<TBHttRequestDelegate> delegate;
- (void) cancelRequest;
- (void) startGetRequest;
+ (id) requestWithParams:(NSDictionary *)paramsDict;
@end

@protocol TBHttRequestDelegate <NSObject>
@optional
- (void) requestFailed:(TBHttRequest *)request;
- (void) requestFinished:(TBHttRequest *)request withDict:(NSDictionary *)dict;
@end