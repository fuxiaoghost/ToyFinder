//
//  SlideViewController.m
//  ToyFinder
//
//  Created by Dawn on 13-5-16.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "SlideViewController.h"

#define SLIDER_BOUND 80
#define ALPHAVIEW_TAG 2111

@interface SlideViewController ()

@end

@implementation SlideViewController
@synthesize backViewController = _backViewController;
@synthesize topViewController = _topViewController;

- (void) dealloc{
    self.backViewController = nil;
    self.topViewController = nil;
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 添加滑动手势
    // 添加滑动手势
    if (!pan) {
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.view addGestureRecognizer:pan];
        [pan release];
    }

}

- (void) setBackViewController:(UIViewController *)backViewController{
    // 如果存在移除之前的View
    if (_backViewController) {
        [_backViewController.view removeFromSuperview];
    }
    
    // 设置属性
    [_backViewController release];
    _backViewController = backViewController;
    [_backViewController retain];
    
    // 把新的back View贴上
    [self.view insertSubview:_backViewController.view atIndex:0];
    _backViewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void) setTopViewController:(UIViewController *)topViewController{
    // 如果存在移除之前的View
    if (_topViewController) {
        [_topViewController.view removeFromSuperview];
    }
    
    // 设置属性
    [_topViewController release];
    _topViewController = topViewController;
    [_topViewController retain];
    
    // 把新的back View 贴上
    [self.view addSubview:_topViewController.view];
    _topViewController.view.frame= CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    // 阴影
    UIView *alphaView =  [[UIView alloc] initWithFrame:CGRectMake(0,-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    alphaView.backgroundColor = RGBACOLOR(0, 0, 0, 0);
    alphaView.tag = ALPHAVIEW_TAG;
    
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 5, SCREEN_WIDTH, 5)];
    shadowView.image = [UIImage noCacheImageNamed:@"slide_top_shadow.png"];
    [alphaView addSubview:shadowView];
    [shadowView release];
    
    [_topViewController.view addSubview:alphaView];
    [alphaView release];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // Check for horizontal pan gesture
    if (gestureRecognizer == pan) {
        
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:self.view];
        
        if ([panGesture velocityInView:self.view].y < 600 && sqrt(translation.y * translation.y) / sqrt(translation.x * translation.x) > 1) {
            if (self.topViewController) {
                return CGRectContainsPoint(self.topViewController.view.frame, [gestureRecognizer locationInView:self.view]);
            }
            return NO;
        }
        
        return NO;
    }
    
    return YES;
    
}

- (void)pan:(UIPanGestureRecognizer*)gesture {
    /*
    if (gesture.state == UIGestureRecognizerStateBegan) {
        backViewController.view.userInteractionEnabled = NO;
        topViewController.view.userInteractionEnabled = NO;
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self.view];
        panOriginY = translation.y;
        
        float y = 0;
        if (isBackShow) {
            y = SLIDER_BOUND + panOriginY;
        }else{
            y = panOriginY;
        }
        if (y > 0) {
            UIView *alphaView = (UIView *)[_rootVC.view viewWithTag:ALPHAVIEW_TAG];
            alphaView.backgroundColor = RGBACOLOR(0, 0, 0, 0.8 - 0.8 * x/LEFTSIDEBAR_WIDTH);
            _rootVC.view.frame = CGRectMake(x,  _rootVC.view.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        if (vcArray.count) {
            if (panOriginX > SLIDER_BOUND) { // (..|->)
                [self slideOutViewController];
            }else if(panOriginX > 0){ // (..|->) (<-|)
                UIViewController *lastViewController = (UIViewController *)[vcArray lastObject];
                
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    lastViewController.view.frame = CGRectMake(0, lastViewController.view.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT);
                    UIView *alphaView = (UIView *)[lastViewController.view viewWithTag:ALPHAVIEW_TAG];
                    alphaView.backgroundColor = RGBACOLOR(0, 0, 0, 0);
                    
                } completion:^(BOOL finished) {
                    BOOL clipsToBounds = [[clipsToBoundsArray lastObject] boolValue];
                    lastViewController.view.clipsToBounds = clipsToBounds;
                }];
            }
        }else{
            if (panOriginX > SLIDER_BOUND) { // (.|->)
                [self showLeftViewController];
                
            }else if(panOriginX > 0){ // (.|->) (<-|)
                if (showingLeftView) {
                    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        _rootVC.view.frame = CGRectMake(LEFTSIDEBAR_WIDTH,  _rootVC.view.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT);
                        UIView *alphaView = (UIView *)[_rootVC.view viewWithTag:ALPHAVIEW_TAG];
                        alphaView.backgroundColor = RGBACOLOR(0, 0, 0, 0);
                    } completion:^(BOOL finished) {
                        _leftVC.view.userInteractionEnabled = YES;
                        tap.enabled = YES;
                    }];
                }else{
                    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        _rootVC.view.frame = CGRectMake(0,  _rootVC.view.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT);
                        UIView *alphaView = (UIView *)[_rootVC.view viewWithTag:ALPHAVIEW_TAG];
                        alphaView.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
                    } completion:^(BOOL finished) {
                        _rootVC.view.userInteractionEnabled = YES;
                        tap.enabled = NO;
                    }];
                }
                
            }else if(panOriginX > - SLIDER_BOUND + (SCREEN_WIDTH - LEFTSIDEBAR_WIDTH)){ // (<-|) (|->)
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    _rootVC.view.frame = CGRectMake(LEFTSIDEBAR_WIDTH,  _rootVC.view.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT);
                    UIView *alphaView = (UIView *)[_rootVC.view viewWithTag:ALPHAVIEW_TAG];
                    alphaView.backgroundColor = RGBACOLOR(0, 0, 0, 0);
                } completion:^(BOOL finished) {
                    _leftVC.view.userInteractionEnabled = YES;
                    tap.enabled = YES;
                }];
            }else if(panOriginX < - SLIDER_BOUND + (SCREEN_WIDTH - LEFTSIDEBAR_WIDTH)){ // (<-|)
                [self showRootViewController];
            }
        }
    }
    */
}

@end
