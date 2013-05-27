//
//  DetailNavgationController.m
//  ToyFinder
//
//  Created by Dawn on 13-5-27.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "DetailNavgationController.h"

@interface DetailNavgationController ()

@end

@implementation DetailNavgationController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.wantsFullScreenLayout = YES;
    self.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Rotate

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return NO;
}

- (BOOL) shouldAutorotate{
    
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


@end
