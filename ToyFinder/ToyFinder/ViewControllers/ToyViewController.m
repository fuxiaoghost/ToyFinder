//
//  RootViewController.m
//  ToyFinder
//
//  Created by Dawn on 13-5-18.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "ToyViewController.h"
#import "ItemView.h"

@interface ToyViewController ()

@end

@implementation ToyViewController

- (id) init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    NSArray *dataSource = [NSArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) dataSource:dataSource itemWidth:260];
    }else{
        itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH) dataSource:dataSource itemWidth:260];
    }
    
    [self.view addSubview:itemView];
    [itemView release];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return YES;
}

- (BOOL) shouldAutorotate{
    
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:{
        }
        case UIInterfaceOrientationLandscapeRight:{
            itemView.itemWidth = 340;
            itemView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
            break;
        }
        case UIInterfaceOrientationPortrait:{
            itemView.itemWidth = 260;
            itemView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            break;
        }
        default:
            break;
    }
    
}

@end
