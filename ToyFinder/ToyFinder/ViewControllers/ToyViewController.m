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
    

    NSArray *dataSource = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 10 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 20 - 44) dataSource:dataSource itemWidth:200];
    }else{
        itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 10 + 44, SCREEN_HEIGHT, SCREEN_WIDTH - 20 - 44) dataSource:dataSource itemWidth:200];
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
            itemView.itemWidth = 300;
            itemView.frame = CGRectMake(0, 10 + 44, SCREEN_HEIGHT,SCREEN_WIDTH - 20 - 44);
            navView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 44);
            break;
        }
        case UIInterfaceOrientationPortrait:{
            itemView.itemWidth = 200;
            itemView.frame = CGRectMake(0, 10 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 20 - 44);
            navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
            break;
        }
        default:
            break;
    }
    
}

@end
