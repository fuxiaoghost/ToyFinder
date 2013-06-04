//
//  BaseViewController.m
//  ToyFinder
//
//  Created by Dawn on 13-5-28.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 导航栏标题
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    }else{
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 44)];
    }
    
    titleLbl.backgroundColor = RGBACOLOR(245,124,0,1);
    titleLbl.font = [UIFont boldSystemFontOfSize:22.0f];
    titleLbl.textAlignment = UITextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLbl];
    [titleLbl release];
    
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
    }else{
        splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_HEIGHT, 1)];
    }
    
    splitView.backgroundColor = RGBACOLOR(217,70,0,1);
    [self.view addSubview:splitView];
    [splitView release];
}

- (void) setTitle:(NSString *)title{
    [super setTitle:title];
    [titleLbl setText:[NSString stringWithFormat:@"%@",title]];
}



- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:{
        }
        case UIInterfaceOrientationLandscapeRight:{
            titleLbl.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 44);
            splitView.frame = CGRectMake(0, 44, SCREEN_HEIGHT, 1);
            break;
        }
        case UIInterfaceOrientationPortrait:{
            titleLbl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
            splitView.frame = CGRectMake(0, 44, SCREEN_WIDTH, 1);
            break;
        }
        default:
            break;
    }
    
}


@end
