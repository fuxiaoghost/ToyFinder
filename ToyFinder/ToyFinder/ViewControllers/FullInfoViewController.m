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
    
    backButton = [WallButton buttonWithType:UIButtonTypeCustom];
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN){
        backButton.frame = CGRectMake(10, 5, 50, 35);
    }else{
        backButton.frame = CGRectMake(10, 5, 50, 35);
    }
    
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:RGBACOLOR(221, 70, 0, 1) forState:UIControlStateNormal];
    [backButton setTitleColor:RGBACOLOR(255, 255, 255, 1) forState:UIControlStateHighlighted];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 信息展示webview
    
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        infoView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45)];
    }else{
        infoView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_HEIGHT, SCREEN_WIDTH - 45)];
    }
    
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
    
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 12, 20, 20)]; 
    }else{
        loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - 30, 12, 20, 20)];
    }
    
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:{
        }
        case UIInterfaceOrientationLandscapeRight:{
            infoView.frame = CGRectMake(0, 45, SCREEN_HEIGHT, SCREEN_WIDTH - 45);
            loadingView.frame = CGRectMake(SCREEN_HEIGHT - 30, 12, 20, 20);
            
            break;
        }
        case UIInterfaceOrientationPortrait:{
            infoView.frame = CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45);
            loadingView.frame = CGRectMake(SCREEN_WIDTH - 30, 12, 20, 20); 
            break;
        }
        default:
            break;
    }
    
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{

}

@end
