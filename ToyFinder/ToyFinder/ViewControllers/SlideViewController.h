//
//  SlideViewController.h
//  ToyFinder
//
//  Created by Dawn on 13-5-16.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideViewController : UIViewController{
@private
    UIPanGestureRecognizer *pan;
    UITapGestureRecognizer *tap;
    float panOriginY;
    BOOL isBackShow;
    int SLIDER_BOUND;
}
@property (nonatomic,retain) UIViewController *backViewController;
@property (nonatomic,retain) UIViewController *topViewController;
@property (nonatomic,assign) BOOL isBackShow;
- (void) slideDown;
- (void) slideUp;
@end
