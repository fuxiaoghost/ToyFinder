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
    float panOriginY;
    BOOL isBackShow;
}
@property (nonatomic,retain) UIViewController *backViewController;
@property (nonatomic,retain) UIViewController *topViewController;
@end
