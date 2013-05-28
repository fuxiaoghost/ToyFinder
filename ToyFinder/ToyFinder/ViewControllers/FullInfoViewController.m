//
//  FullInfoViewController.m
//  ToyFinder
//
//  Created by Dawn on 13-5-28.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "FullInfoViewController.h"
#import "WallButton.h"

@interface FullInfoViewController ()
@end

@implementation FullInfoViewController
@synthesize fullInfo;
@synthesize navUrl;
@synthesize titleInfo;

- (void) dealloc{
    self.fullInfo = nil;
    self.navUrl = nil;
    self.titleInfo = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = self.titleInfo;
    
    WallButton *backButton = [WallButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 5, 50, 35);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:RGBACOLOR(221, 70, 0, 1) forState:UIControlStateNormal];
    [backButton setTitleColor:RGBACOLOR(255, 255, 255, 1) forState:UIControlStateHighlighted];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 信息展示webview
    UIWebView *infoView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45)];
    infoView.delegate = self;
    infoView.scalesPageToFit = YES;
    [self.view addSubview:infoView];
    [infoView release];
    
    if (self.fullInfo) {
        NSString *filePath = RESOURCEFILE(@"fullinfo",@"html");
        NSString *infoHtml = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        infoHtml = [infoHtml stringByReplacingOccurrencesOfString:@"{{content}}" withString:self.fullInfo];
        [infoView loadHTMLString:infoHtml baseURL: [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }else {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.navUrl]];
        [infoView loadRequest:request];
    }
    
    
    
    loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 12, 20, 20)];
    loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    [self.view addSubview:loadingView];
}

- (void)backButtonClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (void) webViewDidStartLoad:(UIWebView *)webView{
    [loadingView startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView{
    [loadingView stopAnimating];
}

@end
