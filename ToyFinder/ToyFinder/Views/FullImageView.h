//
//  FullImageView.h
//  ElongClient
//
//  Created by 赵 海波 on 13-3-29.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoView.h"
@protocol FullImageViewDelegate;
@interface FullImageView : UIView <PhotoViewDelegate> {
@private
    PhotoView *photoPageView;
    BOOL fullScreen;
    UIButton *cancelBtn;
    UILabel *tipsLbl;
    NSInteger index;
    
    NSArray *imagesURL;
    id delegate;
    UILabel *titleLbl;
}
@property (nonatomic,assign) id<FullImageViewDelegate> delegate;
- (void)reloadData;
- (id)initWithFrame:(CGRect)frame Images:(NSArray *)imageURLs AtIndex:(NSInteger)indexNum;

@end

@protocol FullImageViewDelegate <NSObject>

@optional
- (void) fullImageView:(FullImageView *)fullImageView didClosedAtIndex:(NSInteger)index;

@end