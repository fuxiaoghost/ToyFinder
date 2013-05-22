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
    ButtonWallView *buttonWall = [[ButtonWallView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 118)
                                                               buttons:buttonArray];
    buttonWall.delegate = self;
    
    [self.view addSubview:buttonWall];
    [buttonWall release];
}

#pragma mark -
#pragma mark ButtonWallViewDelegate
- (void) didClickButtonAtIndex:(NSInteger)index{
   // NSDictionary *dict = [buttonArray objectAtIndex:index];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SlideViewController *slideVC = (SlideViewController *)delegate.window.rootViewController;
    [slideVC slideUp];
}
@end
