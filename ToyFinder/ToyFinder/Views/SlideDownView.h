//
//  SlideDownView.h
//  ToyFinder
//
//  Created by Wang Shuguang on 13-5-31.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideDownViewDelegate;
@interface SlideDownView : UIView<UITableViewDataSource,UITableViewDelegate>{
@private
    UITableView *sortList;
    NSArray *dataArray;
    UIButton *titleBtn;
    id delegate;
}
@property (nonatomic,assign) id<SlideDownViewDelegate> delegate;
@end

@protocol SlideDownViewDelegate <NSObject>
@optional
- (void) slideDownView:(SlideDownView *)slideDownView didSelectedAtIndex:(NSInteger)index;

@end