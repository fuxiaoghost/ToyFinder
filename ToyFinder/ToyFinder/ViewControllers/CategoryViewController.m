//
//  CategoryViewController.m
//  ToyFinder
//
//  Created by Dawn on 13-5-18.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "CategoryViewController.h"
#import "ButtonWallView.h"
#import "AppDelegate.h"
#import "SlideViewController.h"
#import "ToyViewController.h"
#import "AppDelegate.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

- (void) dealloc{
    [buttonArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    buttonArray = [[NSArray alloc] initWithContentsOfFile:RESOURCEFILE(@"Category", @"plist")];
    buttonWall = [[ButtonWallView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 118)
                                                               buttons:buttonArray];
    buttonWall.delegate = self;
    
    [self.view addSubview:buttonWall];
    [buttonWall release];
    
}


/*
 AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 SlideViewController *slideVC = (SlideViewController *)delegate.window.rootViewController;
 [slideVC slideUp];
 
 ToyViewController *toyVC =  (ToyViewController *)slideVC.topViewController;
 toyVC.titleLbl.text = [dict objectForKey:@"name"];
 [toyVC selectCategoryDict:dict];
 */

#pragma mark -
#pragma mark ButtonWallViewDelegate

- (void) didClickButton:(UIButton *)button atIndex:(NSInteger)index{
    NSDictionary *dict = [buttonArray objectAtIndex:index];
    AppDelegate *appDelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;

    // 阴影
    shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = 0;
    [appDelegate.window addSubview:shadowView];
    [shadowView release];
    
    // 单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [shadowView addGestureRecognizer:singleTap];
    [singleTap release];

    // 按钮的位置
    buttonRect = button.frame;

    // 分类View
    categoryView = [[CategoryView alloc] initWithFrame:CGRectMake((SCREEN_HEIGHT - 300)/2, (SCREEN_WIDTH - 300)/2, 300, 300) categorys:[dict objectForKey:@"cat"]];
    categoryView.alpha = 0;
    categoryView.backgroundColor = [UIColor whiteColor];
    [appDelegate.window addSubview:categoryView];
    [categoryView release];
    
    categoryView.transform = CGAffineTransformMakeScale(buttonRect.size.width/categoryView.frame.size.width , buttonRect.size.height/categoryView.frame.size.width);
    categoryView.center = CGPointMake(buttonRect.origin.x + buttonRect.size.width/2, buttonRect.origin.y + buttonRect.size.height/2);
    
    
    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha = 0.8;
        categoryView.alpha = 1.0f;
        categoryView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        categoryView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)singleTap:(UIGestureRecognizer *)gestureRecognizer{
	[UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha = 0.0;
        categoryView.alpha = 0.0f;
        categoryView.transform = CGAffineTransformMakeScale(buttonRect.size.width/categoryView.frame.size.width , buttonRect.size.height/categoryView.frame.size.width);
        categoryView.center = CGPointMake(buttonRect.origin.x + buttonRect.size.width/2, buttonRect.origin.y + buttonRect.size.height/2);
    } completion:^(BOOL finished) {
        [categoryView removeFromSuperview];
        [shadowView removeFromSuperview];
    }];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:{
        }
        case UIInterfaceOrientationLandscapeRight:{
            buttonWall.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 84);
            break;
        }
        case UIInterfaceOrientationPortrait:{
            buttonWall.frame = CGRectMake(0, 0, SCREEN_WIDTH, 118);
            break;
        }
        default:
            break;
    }
}

@end
