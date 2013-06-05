//
//  PhotoView.h
//  Elong_Shake
//
//  Created by Wang Shuguang on 13-1-5.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PhotoViewDelegate;
@interface PhotoView : UIView<UIScrollViewDelegate>{
@private
    NSInteger photoCount;
    NSInteger page;
    CGSize photoSize;
    UIScrollView *photosView;
    NSMutableArray *photoArray;
    BOOL isScaled;
    id delegate;
}
@property (nonatomic,retain) NSArray *photoUrls;
@property (nonatomic,assign) id<PhotoViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame photoUrls:(NSArray *)urs;
- (void)reloadPhotosWith:(NSArray *)urls;
- (void) pageToIndex:(NSInteger)index;
- (void) setGestureDisabled;
@end


@protocol PhotoViewDelegate <NSObject>
@optional
- (void) photoView:(PhotoView *)photoView didSelectedAtIndex:(NSInteger)index;
- (void) photoView:(PhotoView *)photoView didPageToIndex:(NSInteger)index;
@end