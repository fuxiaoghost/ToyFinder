//
//  CityViewController.m
//  ToyFinder
//
//  Created by Dawn on 13-6-1.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "CityViewController.h"
#import "WallButton.h"

@interface CityViewController ()

@end

@implementation CityViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"筛选";
    
    WallButton *closeButton = [WallButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(SCREEN_WIDTH - 60, 5, 50, 35);
    [closeButton setTitle:@"完成" forState:UIControlStateNormal];
    [closeButton setTitleColor:RGBACOLOR(221, 70, 0, 1) forState:UIControlStateNormal];
    [closeButton setTitleColor:RGBACOLOR(255, 255, 255, 1) forState:UIControlStateHighlighted];
    [self.view addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void) closeButtonClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

@end
