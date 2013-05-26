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
@property (nonatomic,retain) UIButton *catButton;
@end

@implementation CategoryViewController

- (void) dealloc{
    [buttonArray release];
    self.catButton = nil;
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

#pragma mark -
#pragma mark Private Method
- (void) hideCategoryView{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	[UIView animateWithDuration:0.3 animations:^{
        CGRect buttonRect = [self.catButton.superview convertRect:self.catButton.frame toView:appDelegate.window];
        shadowView.alpha = 0.0;
        categoryView.alpha = 0.0f;
        
        if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
            categoryView.transform = CGAffineTransformMakeScale(buttonRect.size.width/categoryView.frame.size.width , buttonRect.size.height/categoryView.frame.size.width);
        }else if(LAYOUT_LANDSCAPELEFT){
            categoryView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI_2), buttonRect.size.width/categoryView.frame.size.width, buttonRect.size.height/categoryView.frame.size.width);
        }else if(LAYOUT_LANDSCAPERIGHT){
            categoryView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI_2), buttonRect.size.width/categoryView.frame.size.width, buttonRect.size.height/categoryView.frame.size.width);
        }
        
        
        categoryView.center = CGPointMake(buttonRect.origin.x + buttonRect.size.width/2, buttonRect.origin.y + buttonRect.size.height/2);
    } completion:^(BOOL finished) {
        [categoryView removeFromSuperview];
        [shadowView removeFromSuperview];
        categoryView = nil;
        shadowView = nil;
        
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        SlideViewController *slideVC = (SlideViewController *)appDelegate.window.rootViewController;
//        [slideVC slideUp];
    }];
}

#pragma mark -
#pragma mark ButtonWallViewDelegate

- (void) didClickButton:(UIButton *)button atIndex:(NSInteger)index_{
    index = index_;
    NSDictionary *dict = [buttonArray objectAtIndex:index];

    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
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
    self.catButton = button;
    CGRect buttonRect = [button.superview convertRect:self.catButton.frame toView:appDelegate.window];

    // 分类View
    categoryView = [[CategoryView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, (SCREEN_HEIGHT - 300)/2, 300, 300) categorys:[dict objectForKey:@"cat"]];
    categoryView.delegate = self;
    categoryView.alpha = 0;
    
    [appDelegate.window addSubview:categoryView];
    [categoryView release];
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        categoryView.transform = CGAffineTransformMakeScale(buttonRect.size.width/categoryView.frame.size.width , buttonRect.size.height/categoryView.frame.size.width);
    }else if(LAYOUT_LANDSCAPELEFT){
        categoryView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI_2), buttonRect.size.width/categoryView.frame.size.width, buttonRect.size.height/categoryView.frame.size.width);
    }else if(LAYOUT_LANDSCAPERIGHT){
        categoryView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-M_PI_2), buttonRect.size.width/categoryView.frame.size.width, buttonRect.size.height/categoryView.frame.size.width);
    }
        

    categoryView.center = CGPointMake(buttonRect.origin.x + buttonRect.size.width/2, buttonRect.origin.y + buttonRect.size.height/2);

    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha = 0.8;
        categoryView.alpha = 1.0f;
        categoryView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
            categoryView.transform = CGAffineTransformIdentity;
        }else if(LAYOUT_LANDSCAPELEFT){
            categoryView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }else if(LAYOUT_LANDSCAPERIGHT){
            categoryView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -
#pragma mark CategoryViewDelegate
- (void) categoryView:(CategoryView *)categoryView didSelectedAtIndex:(NSInteger)subIndex{
    [self hideCategoryView];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SlideViewController *slideVC = (SlideViewController *)appDelegate.window.rootViewController;
    ToyViewController *toyVC =  (ToyViewController *)slideVC.topViewController;
    NSDictionary *dict = [buttonArray objectAtIndex:index];
    NSDictionary *subDict = [[dict objectForKey:@"cat"] objectAtIndex:subIndex];
    toyVC.titleLbl.text = [NSString stringWithFormat:@"%@(%@)",[dict objectForKey:@"name"],[subDict objectForKey:@"name"]];
    NSString *keyword = [NSString stringWithFormat:@"%@ %@",[subDict objectForKey:@"name"],[dict objectForKey:@"tag"]];
    [toyVC selectKeyword:keyword infoUrl:[subDict objectForKey:@"infourl"]];

}

-(void)singleTap:(UIGestureRecognizer *)gestureRecognizer{
    [self hideCategoryView];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:{
            buttonWall.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 84);
            [UIView animateWithDuration:duration animations:^{
                categoryView.transform = CGAffineTransformMakeRotation(-M_PI_2);
            }];
            break;
        }
        case UIInterfaceOrientationLandscapeRight:{
            buttonWall.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 84);
            [UIView animateWithDuration:duration animations:^{
                categoryView.transform = CGAffineTransformMakeRotation(M_PI_2);
            }];
            
            break;
        }
        case UIInterfaceOrientationPortrait:{
            buttonWall.frame = CGRectMake(0, 0, SCREEN_WIDTH, 118);
            [UIView animateWithDuration:duration animations:^{
                categoryView.transform = CGAffineTransformIdentity;
            }];
            break;
        }
        default:
            break;
    }
}

@end
