//
//  untitled.m
//  ElongClient
//
//  Created by bin xing on 11-3-17.
//  Copyright 2011 DP. All rights reserved.
//



#import "NSString+URLEncoding.h"
@implementation NSString (URLEncoding)

- (NSString *)URLEncodedString
{

	//!*'();:@&amp;=+$,/?%#[] 
	CFStringRef cfResult = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																   (CFStringRef)self,
																   NULL,
																   CFSTR("&=@;!'*#%-,:/()<>[]{}?+ "),
																   kCFStringEncodingUTF8);
	
	NSString *result = [NSString stringWithString:(NSString *)cfResult];
	CFRelease(cfResult);
	
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)
	CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
															(CFStringRef)self,
															CFSTR(""),
															kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}
@end