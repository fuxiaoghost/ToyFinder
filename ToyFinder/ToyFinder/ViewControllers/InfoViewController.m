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
    
    // 导航栏标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleLbl.backgroundColor = RGBACOLOR(245,124,0,1);
    titleLbl.font = [UIFont boldSystemFontOfSize:22.0f];
    titleLbl.textAlignment = UITextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLbl];
    [titleLbl release];
    titleLbl.text = self.cid;
    
    
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
    splitView.backgroundColor = RGBACOLOR(217,70,0,1);
    [self.view addSubview:splitView];
    [splitView release];

    
    // 信息展示webview
    UIWebView *infoView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45)];
    infoView.scalesPageToFit = NO;
    [self.view addSubview:infoView];
    [infoView release];
    
    NSString *filePath = RESOURCEFILE(url,@"html");
    NSString *infoHtml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [infoView loadHTMLString:infoHtml baseURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];

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
