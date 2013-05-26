//
//  CategoryView.h
//  ToyFinder
//
//  Created by Wang Shuguang on 13-5-24.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryViewDelegate;
@interface CategoryView : UIView{
    NSInteger imageWidth;
    UIScrollView *contentView;
    id delegate;
}
@property (nonatomic,assign) id<CategoryViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame categorys:(NSArray *)categorys;
@end

@protocol CategoryViewDelegate <NSObject>
@optional
- (void) categoryView:(CategoryView *)categoryView didSelectedAtIndex:(NSInteger)index;

@end