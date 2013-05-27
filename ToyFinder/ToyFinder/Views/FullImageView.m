//
//  FullImageView.m
//  ElongClient
//
//  Created by 赵 海波 on 13-3-29.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FullImageView.h"
#import "UIImageView+WebCache.h"

@implementation FullImageView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame Images:(NSArray *)imageURLs AtIndex:(NSInteger)indexNum {
    self = [super initWithFrame:frame];
    if (self) {
        fullScreen = NO;
        index = indexNum;
        
        /*
         ErrorMessage = "<null>";
         ImageNameCn = "\U897f\U9910\U5385";
         ImagePath = "http://www.elongstatic.com/imageapp/hotels/hotelimages/0101/50101477/889eca66-d7f4-436d-a85d-34faaeeaca83.png";
         ImageSize = 7;
         ImageType = 1;
         IsError = 0;
         UploadImagePath = "http://www.elongstatic.com/imageapp/hotels/hotelimages/0101/50101477/019dfd1e-1b4a-4ef1-bf93-af5103353a02.jpg";
         */
        imagesURL = [[NSArray alloc] initWithArray:imageURLs];
        
        if (imageURLs) {
            photoPageView =  [[PhotoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) photoUrls:imageURLs];
            photoPageView.delegate = self;
            photoPageView.alpha = 0;
            [self addSubview:photoPageView];
            [photoPageView release];
            if (index > 0) {
                [photoPageView pageToIndex:index];
            }
            
            tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 60, SCREEN_WIDTH, 40)];
            tipsLbl.textAlignment = UITextAlignmentCenter;
            tipsLbl.font = [UIFont boldSystemFontOfSize:18.0f];
            tipsLbl.textColor = [UIColor whiteColor];
            tipsLbl.backgroundColor = [UIColor clearColor];
            tipsLbl.text = [NSString stringWithFormat:@"1/%d",imagesURL.count];
            [self addSubview:tipsLbl];
            [tipsLbl release];
            if (index > 0) {
                tipsLbl.text = [NSString stringWithFormat:@"%d/%d",index + 1,imagesURL.count];
            }
        }
        
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.alpha = 0;
        [cancelBtn setImage:[UIImage noCacheImageNamed:@"close_btn.png"] forState:UIControlStateNormal];
        [cancelBtn setImage:[UIImage noCacheImageNamed:@"close_btn_h.png"] forState:UIControlStateHighlighted];
        cancelBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 4, 60, 60);
        [cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        [self setBackgroundDisAppear:YES];
    }
    
    return self;
}


- (void)dealloc {
    [imagesURL release];
    
    [super dealloc];
}


- (void)setBackgroundDisAppear:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             photoPageView.alpha = 1;
                             cancelBtn.alpha = 1;
                             self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
                         }
                         completion:^(BOOL finished) {
                             // todo
                         }];
    }
    else {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
}


- (void)cancelButtonClick:(id)sender {
    self.userInteractionEnabled = NO;
    [self setBackgroundDisAppear:NO];
    
    if ([delegate respondsToSelector:@selector(fullImageView:didClosedAtIndex:)]) {
        [delegate fullImageView:self didClosedAtIndex:index];
    }
}

- (void)reloadData {
    [photoPageView reloadPhotosWith:imagesURL];
}


#pragma mark -
#pragma mark PhotoViewDelegate

- (void)photoView:(PhotoView *)photoView didPageToIndex:(NSInteger)indexNum {
    tipsLbl.text = [NSString stringWithFormat:@"%d/%d", indexNum + 1, imagesURL.count];
    index = indexNum;
}

// 取消单击取消
//- (void) photoView:(PhotoView *)photoView didSelectedAtIndex:(NSInteger)index {
//    [self cancelButtonClick:nil];
//}

@end
