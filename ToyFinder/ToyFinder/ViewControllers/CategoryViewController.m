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
    ButtonWallView *buttonWall = [[ButtonWallView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)
                                                               buttons:buttonArray];
    
    [self.view addSubview:buttonWall];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
