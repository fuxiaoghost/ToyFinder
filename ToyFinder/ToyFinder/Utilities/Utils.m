//
//  Utils.m
//  ToyFinder
//
//  Created by Dawn on 13-6-2.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "Utils.h"
#import "AppDelegate.h"
#include <QuartzCore/QuartzCore.h>

#define LOADING_TAG 2001

@implementation Utils

+ (void) showLoadingTitle:(NSString *)title{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    loadingView.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
    loadingView.layer.cornerRadius = 5.0f;
    [appDelegate.window addSubview:loadingView];
    [loadingView release];
    loadingView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    loadingView.tag = LOADING_TAG;
    
    UIActivityIndicatorView *activeView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    activeView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activeView.center = CGPointMake(loadingView.frame.size.width/2, loadingView.frame.size.height/2);
    [loadingView addSubview:activeView];
    [activeView release];
    
    appDelegate.window.userInteractionEnabled = NO;
    [activeView startAnimating];
    
    loadingView.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [UIView animateWithDuration:0.2 animations:^{
        loadingView.transform =CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            loadingView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

+ (void) dismissLoading{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView *loadingView = (UIView *)[appDelegate.window viewWithTag:LOADING_TAG];
    if (loadingView) {
        [loadingView removeFromSuperview];
    }
    appDelegate.window.userInteractionEnabled = YES;
}
@end
