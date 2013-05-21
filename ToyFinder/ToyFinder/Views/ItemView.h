//
//  ItemView.h
//  ToyFinder
//
//  Created by Dawn on 13-5-19.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemContentView.h"

@protocol ItemViewDelegate;
@class ItemCell;
@interface ItemView : UIView<UITableViewDataSource,UITableViewDelegate>{
@private
    ItemContentView *itemContentView;       // 滑动控件的容器，用于做碰撞测试
    NSInteger itemCount;                    // 数据源容量
    NSInteger page;                         // 当前页码
    UIScrollView *itemScrollView;           // 图片滑动控件
    NSMutableArray *itemArray;              // 缓存容器
    id delegate;
}
@property (nonatomic,assign) id<ItemViewDelegate> delegate;     // 委托
@property (nonatomic,retain) NSArray *dataSource;               // 数据源
@property (nonatomic,assign) float itemWidth;
- (id)initWithFrame:(CGRect)frame dataSource:(NSArray *)ds itemWidth:(float)width;
- (void) pageToIndex:(NSInteger)index;
@end

@protocol ItemViewDelegate <NSObject>
- (void) itemView:(ItemView *)itemView didSelectedAtIndex:(NSInteger)index;
- (void) itemView:(ItemView *)itemView didPageToIndex:(NSInteger)index;
@end