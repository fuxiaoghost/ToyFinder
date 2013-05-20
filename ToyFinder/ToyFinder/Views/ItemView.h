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
@interface ItemView : UIView<UITableViewDataSource,UITableViewDelegate>{
@private
    ItemContentView *itemContentView;       // 滑动控件的容器，用于做碰撞测试
    NSInteger itemCount;                    // 数据源容量
    NSInteger page;                         // 当前页码
    UIScrollView *itemScrollView;           // 图片滑动控件
    NSMutableArray *itemArray;              // 缓存容器
    id delegate;
    float scrollX;
}
@property (nonatomic,assign) id<ItemViewDelegate> delegate;
@property (nonatomic,retain) NSArray *dataSource;
- (id)initWithFrame:(CGRect)frame dataSource:(NSArray *)ds;
- (void) pageToIndex:(NSInteger)index;
@end

@protocol ItemViewDelegate <NSObject>
- (void) itemView:(ItemView *)itemView didSelectedAtIndex:(NSInteger)index;
- (void) itemView:(ItemView *)itemView didPageToIndex:(NSInteger)index;
@end