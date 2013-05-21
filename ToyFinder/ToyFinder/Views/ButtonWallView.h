//
//  ButtonWallView.h
//  ToyFinder
//
//  Created by Wang Shuguang on 13-5-21.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ButtonWallViewDelegate;
@interface ButtonWallView : UIView{
@private
    id delegate;
    UIScrollView *contentView;
}
@property (nonatomic,assign) id <ButtonWallViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame buttons:(NSArray *)buttons;
@end


@protocol ButtonWallViewDelegate <NSObject>

- (void) didClickButtonAtIndex:(NSInteger) index;

@end