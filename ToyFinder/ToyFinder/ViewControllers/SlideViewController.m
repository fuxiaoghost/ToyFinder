//
//  SlideViewController.m
//  ToyFinder
//
//  Created by Dawn on 13-5-16.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "SlideViewController.h"


#define SLIDER_BOUND_SPACE 10
#define ALPHAVIEW_TAG 2111
#define SHADOWVIEW_TAG 2112
#define SLIDER_TIME 0.3
#define BACKVIEW_SCALE 0.9

@interface SlideViewController ()

@end

@implementation SlideViewController
@synthesize backViewController = _backViewController;
@synthesize topViewController = _topViewController;
@synthesize isBackShow;

- (void) dealloc{
    self.backViewController = nil;
    self.topViewController = nil;
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        SLIDER_BOUND = 118;
    }else{
        SLIDER_BOUND = 84;
    }
    
    
    // 添加滑动手势
    if (!pan) {
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.view addGestureRecognizer:pan];
        [pan release];
    }

    // 添加单击手势
    if (!tap) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.view addGestureRecognizer:tap];
        [tap setEnabled:NO];
        [tap release];
    }
}

#pragma mark -
#pragma mark Private Methods
- (void) showBackViewController:(float)time{
    [UIView beginAnimations:@"BackView" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:time];
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        self.topViewController.view.frame = CGRectMake(0, SLIDER_BOUND, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else{
        self.topViewController.view.frame = CGRectMake(0, SLIDER_BOUND, SCREEN_HEIGHT, SCREEN_WIDTH);
    }
    self.backViewController.view.transform = CGAffineTransformIdentity;
    
    UIView *alphaView = (UIView *)[self.topViewController.view viewWithTag:ALPHAVIEW_TAG];
    alphaView.backgroundColor = RGBACOLOR(0, 0, 0, 0);
    
    tap.enabled = YES;
    [self.backViewController viewWillAppear:YES];
    isBackShow = YES;
    self.backViewController.view.userInteractionEnabled = YES;
    self.topViewController.view.userInteractionEnabled = NO;
    
    [UIView commitAnimations];
}

- (void) hideBackViewController:(float)time{    
    [UIView beginAnimations:@"HideView" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:time];
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        self.topViewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else{
        self.topViewController.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    }
    
    self.backViewController.view.transform = CGAffineTransformMakeScale(BACKVIEW_SCALE, BACKVIEW_SCALE);
    
    UIView *alphaView = (UIView *)[self.topViewController.view viewWithTag:ALPHAVIEW_TAG];
    alphaView.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
    
    tap.enabled = NO;
    isBackShow = NO;
    self.topViewController.view.userInteractionEnabled = YES;
    self.backViewController.view.userInteractionEnabled = NO;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(resetBackTrans) withObject:nil afterDelay:0.3];
}

- (void) resetBackTrans{
    self.backViewController.view.transform = CGAffineTransformIdentity;
}

#pragma mark -
#pragma mark PublicMethods
- (void) slideDown{
    [self showBackViewController:SLIDER_TIME];
}

- (void) slideUp{
    [self hideBackViewController:SLIDER_TIME];
}

#pragma mark -
#pragma mark Properties

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
    
    if (LAYOUT_UPSIDEDOWN || LAYOUT_PORTRAIT) {
       _backViewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT); 
    }else{
        _backViewController.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    }
    
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
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        _topViewController.view.frame= CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else{
        _topViewController.view.frame= CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    }
    
    
    
    // 阴影
    UIView *alphaView =  [[UIView alloc] initWithFrame:CGRectMake(0,-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    alphaView.backgroundColor = RGBACOLOR(0, 0, 0, 0);
    alphaView.tag = ALPHAVIEW_TAG;
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        alphaView.frame = CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else{
        alphaView.frame = CGRectMake(0, -SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH);
    }
    
    UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 5, SCREEN_WIDTH, 5)];
    shadowView.image = [UIImage noCacheImageNamed:@"slide_top_shadow.png"];
    shadowView.tag = SHADOWVIEW_TAG;
    [alphaView addSubview:shadowView];
    [shadowView release];
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        shadowView.frame = CGRectMake(0, SCREEN_HEIGHT - 5, SCREEN_WIDTH, 5);
    }else{
        shadowView.frame = CGRectMake(0, SCREEN_WIDTH - 5, SCREEN_HEIGHT, 5);
    }
    
    [_topViewController.view addSubview:alphaView];
    [alphaView release];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == tap) {
        
        if (self.topViewController && isBackShow) {
            return CGRectContainsPoint(self.topViewController.view.frame, [gestureRecognizer locationInView:self.view]);
        }
        
        return NO;
    }
    
    // Check for horizontal pan gesture
    if (gestureRecognizer == pan) {
        
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:self.view];
        
        if (sqrt(translation.y * translation.y) / sqrt(translation.x * translation.x) > 1) {
            if (self.topViewController) {
                return CGRectContainsPoint(self.topViewController.view.frame, [gestureRecognizer locationInView:self.view]);
            }
            return NO;
        }
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == tap) {
        return YES;
    }
    return NO;
}

- (void)tap:(UITapGestureRecognizer*)gesture {
    [tap setEnabled:NO];
    [self hideBackViewController:SLIDER_TIME];
}

- (void)pan:(UIPanGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.backViewController.view.userInteractionEnabled = NO;
        self.topViewController.view.userInteractionEnabled = NO;
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self.view];
        panOriginY = translation.y;
        
        float y = 0;
        if (isBackShow) {
            y = SLIDER_BOUND + panOriginY;
        }else{
            y = panOriginY;
        }
        if (y >= 0 && y <= SLIDER_BOUND) {
            UIView *alphaView = (UIView *)[self.topViewController.view viewWithTag:ALPHAVIEW_TAG];
            alphaView.backgroundColor = RGBACOLOR(0, 0, 0, 0.8 - 0.8 * y/SLIDER_BOUND);
            if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
                self.topViewController.view.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT);
                
            }else{
                self.topViewController.view.frame = CGRectMake(0, y, SCREEN_HEIGHT, SCREEN_WIDTH);
            }
            
            self.backViewController.view.transform = CGAffineTransformMakeScale(BACKVIEW_SCALE + (1-BACKVIEW_SCALE)*y/SLIDER_BOUND, BACKVIEW_SCALE + (1-BACKVIEW_SCALE)*y/SLIDER_BOUND);
        }
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {

        if (panOriginY > SLIDER_BOUND_SPACE) { // (.|->)
            [self showBackViewController:SLIDER_TIME * (SLIDER_BOUND - panOriginY + 0.0)/SLIDER_BOUND];
        }else if(panOriginY > 0 && !isBackShow){ // (.|->) (<-|)
            if (isBackShow) {
                [self showBackViewController:(panOriginY + 0.0) * SLIDER_TIME/SLIDER_BOUND];
            }else{
                [self hideBackViewController:(panOriginY + 0.0) * SLIDER_TIME/SLIDER_BOUND];
            }
            
        }else if(panOriginY > - SLIDER_BOUND_SPACE){ // (<-|) (|->)
            [self showBackViewController:SLIDER_TIME * (panOriginY + SLIDER_BOUND_SPACE + 0.0)/SLIDER_BOUND];
        }else if(panOriginY < - SLIDER_BOUND_SPACE){ // (<-|)
            [self hideBackViewController:SLIDER_TIME * (0.0 + SLIDER_BOUND + panOriginY)/SLIDER_BOUND];
        }
    }
}

- (BOOL)shouldAutorotate{
    [super shouldAutorotate];
    return [self.topViewController shouldAutorotate];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation!=UIInterfaceOrientationPortraitUpsideDown;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.topViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.backViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:{
        }
        case UIInterfaceOrientationLandscapeRight:{
            UIView *alphaView = (UIView *)[self.topViewController.view viewWithTag:ALPHAVIEW_TAG];
            UIView *shadowView = (UIView *)[self.topViewController.view viewWithTag:SHADOWVIEW_TAG];
            alphaView.frame = CGRectMake(0, -SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_WIDTH);
            shadowView.frame = CGRectMake(0, SCREEN_WIDTH - 5, SCREEN_HEIGHT, 5);
            SLIDER_BOUND = 84;
            break;
        }
        case UIInterfaceOrientationPortrait:{
            UIView *alphaView = (UIView *)[self.topViewController.view viewWithTag:ALPHAVIEW_TAG];
            UIView *shadowView = (UIView *)[self.topViewController.view viewWithTag:SHADOWVIEW_TAG];
            alphaView.frame = CGRectMake(0,-SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            shadowView.frame = CGRectMake(0, SCREEN_HEIGHT - 5, SCREEN_WIDTH, 5);
            SLIDER_BOUND = 118;
            break;
        }
        default:
            break;
    }
}

- (NSUInteger)supportedInterfaceOrientations{
    [super supportedInterfaceOrientations];
    return self.topViewController.supportedInterfaceOrientations;
}

@end
