//
//  DetailNavgationController.m
//  ToyFinder
//
//  Created by Dawn on 13-5-27.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "DetailNavgationController.h"
#import "AppDelegate.h"
#import "SlideViewController.h"

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
    
    return toInterfaceOrientation != UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL) shouldAutorotate{
    
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SlideViewController *slideVC = (SlideViewController *)appDelegate.window.rootViewController;
    [slideVC willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
   
    for (UIViewController *vc in self.viewControllers) {
        [vc willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
    
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SlideViewController *slideVC = (SlideViewController *)appDelegate.window.rootViewController;
    [slideVC didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    for (UIViewController *vc in self.viewControllers) {
        [vc didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
}
@end
