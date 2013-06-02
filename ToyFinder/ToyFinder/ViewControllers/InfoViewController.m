//
//  InfoViewController.m
//  ToyFinder
//
//  Created by Dawn on 13-5-26.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "InfoViewController.h"
#import "WallButton.h"

@interface InfoViewController ()
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *cid;
@end

@implementation InfoViewController
@synthesize url;

- (void) dealloc{
    self.url = nil;
    self.cid = nil;
    [super dealloc];
}

- (id) initWithUrl:(NSString *)url_ title:(NSString *)title_{
    if (self = [super init]) {
        self.url = url_;
        self.cid = title_;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = self.cid;
    
    
    // 信息展示webview
    UIWebView *infoView = nil;
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        infoView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45)];
    }else{
        infoView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_HEIGHT, SCREEN_WIDTH - 45)];
    }
    
    infoView.scalesPageToFit = NO;
    [self.view addSubview:infoView];
    [infoView release];
    
    NSString *filePath = RESOURCEFILE(url,@"html");
    NSString *infoHtml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [infoView loadHTMLString:infoHtml baseURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];

    WallButton *closeButton = [WallButton buttonWithType:UIButtonTypeCustom];
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        closeButton.frame = CGRectMake(SCREEN_WIDTH - 60, 5, 50, 35);
    }else{
        closeButton.frame = CGRectMake(SCREEN_HEIGHT - 60, 5, 50, 35);
    }
    
    [closeButton setTitle:@"完成" forState:UIControlStateNormal];
    [closeButton setTitleColor:RGBACOLOR(221, 70, 0, 1) forState:UIControlStateNormal];
    [closeButton setTitleColor:RGBACOLOR(255, 255, 255, 1) forState:UIControlStateHighlighted];
    [self.view addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) closeButtonClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
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
