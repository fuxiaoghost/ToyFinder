//
//  FullImageViewController.m
//  ToyFinder
//
//  Created by Wang Shuguang on 13-6-4.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "FullImageViewController.h"

@interface FullImageViewController ()
@property (nonatomic,retain) NSArray *imageArray;

@end

@implementation FullImageViewController
@synthesize imageArray;
@synthesize delegate;

- (void) dealloc{
    self.imageArray = nil;
    [super dealloc];
}

- (id)initWithImages:(NSArray *)imageURLs AtIndex:(NSInteger)indexNum {
    if (self = [super init]) {
        index = indexNum;
        self.imageArray = imageURLs;
       
    }
    
    return self;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    if (self.imageArray) {
        if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
            photoPageView =  [[PhotoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) photoUrls:self.imageArray];
        }else{
            photoPageView =  [[PhotoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH) photoUrls:self.imageArray];
        }
        
        photoPageView.delegate = self;
        [self.view addSubview:photoPageView];
        [photoPageView release];
        if (index > 0) {
            [photoPageView pageToIndex:index];
        }
        
        if(LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN){
            tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 40)];
        }else{
            tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH - 60, SCREEN_HEIGHT, 40)];
        }
        
        tipsLbl.textAlignment = UITextAlignmentCenter;
        tipsLbl.font = [UIFont boldSystemFontOfSize:18.0f];
        tipsLbl.textColor = [UIColor whiteColor];
        tipsLbl.backgroundColor = [UIColor clearColor];
        tipsLbl.text = [NSString stringWithFormat:@"1/%d",self.imageArray.count];
        [self.view addSubview:tipsLbl];
        [tipsLbl release];
        if (index > 0) {
            tipsLbl.text = [NSString stringWithFormat:@"%d/%d",index + 1,self.imageArray.count];
        }
    }
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage noCacheImageNamed:@"close_btn.png"] forState:UIControlStateNormal];
    [cancelBtn setImage:[UIImage noCacheImageNamed:@"close_btn_h.png"] forState:UIControlStateHighlighted];
    if(LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN){
        cancelBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 4, 60, 60); 
    }else{
        cancelBtn.frame = CGRectMake(SCREEN_HEIGHT - 60, 4, 60, 60);
    }
    
    [cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}


- (void)cancelButtonClick:(id)sender {
    
    if ([delegate respondsToSelector:@selector(fullImageViewController:didClosedAtIndex:)]) {
        [delegate fullImageViewController:self didClosedAtIndex:index];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadData {
    [photoPageView reloadPhotosWith:self.imageArray];
}


#pragma mark -
#pragma mark PhotoViewDelegate

- (void)photoView:(PhotoView *)photoView didPageToIndex:(NSInteger)indexNum {
    tipsLbl.text = [NSString stringWithFormat:@"%d/%d", indexNum + 1, self.imageArray.count];
    index = indexNum;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:{
        }
        case UIInterfaceOrientationLandscapeRight:{
            photoPageView.frame = CGRectMake(0, 0, SCREEN_HEIGHT,SCREEN_WIDTH);
            tipsLbl.frame = CGRectMake(0, SCREEN_WIDTH - 60, SCREEN_HEIGHT, 40);
            cancelBtn.frame = CGRectMake(SCREEN_HEIGHT - 60, 4, 60, 60);
            break;
        }
        case UIInterfaceOrientationPortrait:{
            photoPageView.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
            tipsLbl.frame = CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 40);
            cancelBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 4, 60, 60);
            break;
        }
        default:
            break;
    }
}



@end
