//
//  CacheManager.h
//  ToyFinder
//
//  Created by Wang Shuguang on 13-5-30.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject{
    
}
+ (id)manager;
- (void) cacheData:(NSString *)data forKey:(NSString *)keystr;
- (NSString *) cacheForKey:(NSString *)keystr;
@end
