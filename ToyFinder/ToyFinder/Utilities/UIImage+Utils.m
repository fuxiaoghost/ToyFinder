//
//  UIImage+Utils.m
//  Elong_Shake
//
//  Created by Wang Shuguang on 12-12-19.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)
+ (UIImage *)noCacheImageNamed:(NSString *)name {
	UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
	return image;
}


+ (UIImage *)stretchableImageWithPath:(NSString *)path {
	UIImage *stretchImg = [UIImage noCacheImageNamed:path];
	return [stretchImg stretchableImageWithLeftCapWidth:stretchImg.size.width / 2
										   topCapHeight:stretchImg.size.height / 2];
}


- (id)imageToSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
	[self drawInRect:imageRect];
	self = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return self;
}

@end
