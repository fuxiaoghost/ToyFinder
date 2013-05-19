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
    ItemContentView *itemContentView;
    NSInteger itemCount;
    NSInteger page;
    UIScrollView *itemScrollView;
    NSMutableArray *itemArray;
    id delegate;
}
@property (nonatomic,assign) id<ItemViewDelegate> delegate;
@property (nonatomic,retain) NSArray *dataSource;
- (id)initWithFrame:(CGRect)frame dataSource:(NSArray *)ds;
@end

@protocol ItemViewDelegate <NSObject>
- (void) itemView:(ItemView *)itemView didSelectedAtIndex:(NSInteger)index;
- (void) itemView:(ItemView *)itemView didPageToIndex:(NSInteger)index;
@end