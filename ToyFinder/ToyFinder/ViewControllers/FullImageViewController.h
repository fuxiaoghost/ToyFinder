//
//  FullImageViewController.h
//  ToyFinder
//
//  Created by Wang Shuguang on 13-6-4.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoView.h"

@protocol FullImageViewControllerDelegate;
@interface FullImageViewController : UIViewController<PhotoViewDelegate>{
@private
    PhotoView *photoPageView;
    UIButton *cancelBtn;
    UILabel *tipsLbl;
    NSInteger index;
    
    id delegate;
    UILabel *titleLbl;
}
@property (nonatomic,assign) id<FullImageViewControllerDelegate> delegate;
- (void)reloadData;
- (id)initWithImages:(NSArray *)imageURLs AtIndex:(NSInteger)indexNum;

@end

@protocol FullImageViewControllerDelegate <NSObject>

@optional
- (void) fullImageViewController:(FullImageViewController *)fullImageVC didClosedAtIndex:(NSInteger)index;

@end
