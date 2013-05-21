//
//  CategoryViewController.m
//  ToyFinder
//
//  Created by Dawn on 13-5-18.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "CategoryViewController.h"
#import "ButtonWallView.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSArray *buttonArray = [NSArray arrayWithContentsOfFile:RESOURCEFILE(@"Category", @"plist")];
    ButtonWallView *buttonWall = [[ButtonWallView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)
                                                               buttons:buttonArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
