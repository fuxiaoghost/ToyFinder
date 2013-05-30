//
//  CacheManager.m
//  ToyFinder
//
//  Created by Wang Shuguang on 13-5-30.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "CacheManager.h"
#import <CommonCrypto/CommonDigest.h>

#define CACHE_PATH @"Caches"
#define CACHE_INTERVAL 60*10

static CacheManager *cacheManager = nil;

@implementation CacheManager

+ (id)manager {
    @synchronized(cacheManager) {
        if (!cacheManager) {
            cacheManager = [[CacheManager alloc] init];
        }
    }
    
    return cacheManager;
}

- (NSString *)cachePathForKey:(NSString *)key {
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

- (void) cacheData:(NSData *)data forKey:(NSString *)keystr{
    NSString *key = [self cachePathForKey:keystr];
    //配置文件夹路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:CACHE_PATH];
    
    //检测配置文件夹是否存在，如果不存在就创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:cPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:cPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    cPath = [cPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.cache",key]];
    
    [data writeToFile:cPath atomically:YES];
}

- (NSDictionary *)scanFileAtPath:(NSString *)path withFileOutTime:(long long)seconds {
    // 返回文件信息
    NSDictionary *fileAttribute = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSDate *modifyDate = [fileAttribute objectForKey:NSFileModificationDate]; // 取出文件上次的修改时间
    if ([[NSDate date] timeIntervalSinceDate:modifyDate] > seconds) {
        // 超时文件删除
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return nil;
    }
    return fileAttribute;
}

- (NSData *) cacheForKey:(NSString *)keystr{
    NSString *key = [self cachePathForKey:keystr];
    //配置文件夹路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:CACHE_PATH];
    
    //检测配置文件夹是否存在，如果不存在就创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:cPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:cPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    cPath = [cPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.cache",key]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cPath]){
        NSDictionary *fileInfoDict = [self scanFileAtPath:cPath withFileOutTime:CACHE_INTERVAL];
        if (fileInfoDict == nil) {
            return nil;
        }else{
            return [NSData dataWithContentsOfFile:cPath];
        }
    }else{
        return nil;
    }
    return nil;
}

@end
