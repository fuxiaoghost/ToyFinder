//
//  UIImage+Utils.h
//  Elong_Shake
//
//  Created by Wang Shuguang on 12-12-19.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)
+ (UIImage *)noCacheImageNamed:(NSString *)name;
+ (UIImage *)stretchableImageWithPath:(NSString *)path;
- (id)imageToSize:(CGSize)size;
@end
