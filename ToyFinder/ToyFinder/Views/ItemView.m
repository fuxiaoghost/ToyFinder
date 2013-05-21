//
//  ItemView.m
//  ToyFinder
//
//  Created by Dawn on 13-5-19.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "ItemView.h"
#import "ItemCell.h"
#import "ItemContentView.h"
#define ITEM_CACHECOUNT 3       // 缓存容量
#define ITEM_TAG 2013
#define ITEM_SCALE  0.9         // 缩放大小

@implementation ItemView
@synthesize delegate;
@synthesize dataSource = _dataSource;
@synthesize itemWidth;

- (void) dealloc{
    self.dataSource = nil;
    [itemArray release];
    [super dealloc];
}


// 初始化图片
- (id)initWithFrame:(CGRect)frame dataSource:(NSArray *)ds itemWidth:(float)width{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置数据源
        [_dataSource release];
        _dataSource = ds;
        [_dataSource retain];
        
        // 图片数量
        if (self.dataSource) {
            itemCount = self.dataSource.count;
        }else{
            itemCount = 0;
        }
        
        // 当前页码
        page = 0;
        
        self.itemWidth = width;
        
        // item容器
        itemContentView = [[ItemContentView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:itemContentView];
        [itemContentView release];
        
        // item滚动翻页容器
        itemScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((frame.size.width - self.itemWidth)/2, 0, self.itemWidth, itemContentView.frame.size.height)];
        itemScrollView.showsHorizontalScrollIndicator = NO;
        itemScrollView.showsVerticalScrollIndicator = NO;
        itemScrollView.tag = ITEM_TAG;
        itemScrollView.pagingEnabled = YES;
        itemScrollView.contentSize = CGSizeMake(itemCount * self.itemWidth, itemScrollView.frame.size.height);
        itemScrollView.delegate = self;
        itemScrollView.clipsToBounds = NO;
        [itemContentView addSubview:itemScrollView];
        [itemScrollView release];
        
        // 页面中图片在内存中的容器
        itemArray = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < ITEM_CACHECOUNT && i < self.dataSource.count; i++) {
            NSInteger x = self.itemWidth * i;
            NSInteger y = 0;
            
            ItemCell *itemCell = [[ItemCell alloc] initWithFrame:CGRectMake(x, y, itemScrollView.frame.size.width, itemScrollView.frame.size.height)];
            
            if (i == 0) {
                itemCell.bgView.backgroundColor = [UIColor redColor];
            }else if(i == 1){
                itemCell.bgView.backgroundColor = [UIColor greenColor];
            }else{
                itemCell.bgView.backgroundColor = [UIColor orangeColor];
            }
            
            [self renderItemCell:itemCell atIndex:i];
            
            // 单击手势
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
            singleTap.numberOfTapsRequired = 1;
            singleTap.numberOfTouchesRequired = 1;
            [itemCell addGestureRecognizer:singleTap];
            [singleTap release];
            
            [itemArray addObject:itemCell];
            [itemScrollView addSubview:itemCell];
            [itemCell release];
        }
        
        [self layoutItemCellAtIndex:0];
        
    }
    return self;
}


#pragma mark -
#pragma mark Properties

// 设置数据源，同时会刷新
- (void) setDataSource:(NSArray *)dataSource{
    [_dataSource release];
    _dataSource = dataSource;
    [_dataSource retain];
    
    if (dataSource) {
        itemCount = dataSource.count;
    }else{
        itemCount = 0;
    }
    page = 0;
    
    if (itemCount == 0) {
        return;
        
    }
    
    if (itemArray.count != ITEM_CACHECOUNT || dataSource.count != ITEM_CACHECOUNT) {
        [itemArray removeAllObjects];
        for (ItemCell *itemCell in itemScrollView.subviews) {
            [itemCell removeFromSuperview];
        }
        
        for (int i = 0; i < ITEM_CACHECOUNT && i < self.dataSource.count; i++) {
            NSInteger x = self.itemWidth * i;
            NSInteger y = 0;
            
            ItemCell *itemCell = [[ItemCell alloc] initWithFrame:CGRectMake(x, y, itemScrollView.frame.size.width, itemScrollView.frame.size.height)];
            
            [self renderItemCell:itemCell atIndex:i];
            
            // 单击手势
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
            singleTap.numberOfTapsRequired = 1;
            singleTap.numberOfTouchesRequired = 1;
            [itemCell addGestureRecognizer:singleTap];
            [singleTap release];
            
            [itemArray addObject:itemCell];
            [itemScrollView addSubview:itemCell];
            [itemCell release];
        }
        
        [self layoutItemCellAtIndex:0];
    }else{
        for (int i = 0; i < ITEM_CACHECOUNT; i++) {
            ItemCell *itemCell =  (ItemCell *)[itemArray objectAtIndex:i];
            NSInteger x = self.itemWidth * i;
            NSInteger y = 0;
            itemCell.frame = CGRectMake(x, y, itemScrollView.frame.size.width, itemScrollView.frame.size.height);
            
            [self renderItemCell:itemCell atIndex:i];
        }
    }
}

#pragma mark -
#pragma Private Methods
- (void) renderItemCell:(ItemCell *)itemCell  atIndex:(NSInteger)index{
    
}

- (void) layoutItemCellAtIndex:(NSInteger)index{
    for (int i = 0; i < itemArray.count; i++) {
        ItemCell *itemCell =  (ItemCell *)[itemArray objectAtIndex:i];
        if (index == i) {
            itemCell.contentTransform =  CGAffineTransformIdentity;
        }else{
            itemCell.contentTransform =  CGAffineTransformScale(CGAffineTransformIdentity, ITEM_SCALE, ITEM_SCALE);
        }
    }
}


// 上翻页
- (void) photoPageUp{
    NSInteger index = page - 1;
    if (index >= itemCount) {
        return;
    }
    
    // 交换数据源
    for (int i = ITEM_CACHECOUNT - 1; i > 0; i--) {
		[itemArray exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
	}
    
    ItemCell *itemCell = [itemArray objectAtIndex:0];
    [self renderItemCell:itemCell atIndex:index];
    
    itemCell.frame = CGRectMake(index * self.itemWidth, 0, itemCell.frame.size.width, itemCell.frame.size.height);
}

// 下翻页
- (void) photoPageDown{
    NSInteger index = page + 1;
    if (index >= itemCount) {
        return;
    }
    
    // 交换数据源
    for (int i = 0; i < ITEM_CACHECOUNT - 1; i++) {
		[itemArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
	}
    
    ItemCell *itemCell = [itemArray objectAtIndex:ITEM_CACHECOUNT - 1];
    [self renderItemCell:itemCell atIndex:index];
    
    itemCell.frame = CGRectMake(index * self.itemWidth, 0, itemCell.frame.size.width, itemCell.frame.size.height);
}

// 无刷新下翻页
- (void) photoPageDownSilently{
    NSInteger index = page + 1;
    if (index >= itemCount) {
        return;
    }
    
    // 交换数据源
    for (int i = 0; i < ITEM_CACHECOUNT - 1; i++) {
		[itemArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
	}
    
    ItemCell *itemCell = [itemArray objectAtIndex:ITEM_CACHECOUNT - 1];
    
    //[self renderItemCell:itemCell atIndex:index];
    
    itemCell.frame = CGRectMake(index * self.itemWidth, 0, itemCell.frame.size.width, itemCell.frame.size.height);
    
    
}

#pragma mark -
#pragma mark Public Methods

// 翻到指定的页码
- (void) pageToIndex:(NSInteger)_index{
    if (_index == 0) {
        return;
    }else if(_index == 1){
        itemScrollView.contentOffset = CGPointMake(self.itemWidth, 0);
    }else{
        for (int i = 0; i < _index + 1; i++) {
            page = i;
            [self photoPageDown];
        }
        itemScrollView.contentOffset = CGPointMake(self.itemWidth * _index, 0);
    }
}

#pragma mark -
#pragma mark GestureRecognizer

-(void)singleTap:(UIGestureRecognizer *)gestureRecognizer{
	if ([delegate respondsToSelector:@selector(itemView:didSelectedAtIndex:)]) {
        [delegate itemView:self didSelectedAtIndex:page];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
	if (scrollView != itemScrollView) {
		return;
	}
    
    float tpagef = (scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width + 1;
    
	NSInteger tpage = floor(tpagef);
    
	
    if (tpage > page && tpage > 1 && tpage < itemCount - 1) {
        page = tpage;
        [self photoPageDown];
    }else if(tpage < page && tpage < itemCount - 2 && tpage > 0){
        page = tpage;
        [self photoPageUp];
    }else{
        page = tpage;
    }
    
    if (tpage == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutItemCellAtIndex:0];
        }];
    }else if(tpage == itemCount - 1){
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutItemCellAtIndex:2];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutItemCellAtIndex:1];
        }];
    }
    
    if ([delegate respondsToSelector:@selector(itemView:didPageToIndex:)]) {
        [delegate itemView:self didPageToIndex:page];
    }
}


#pragma mark -
#pragma mark Over write LayoutSubviews

// 重新调整所有的子类控件
#pragma mark -
#pragma mark Layout Subviews
- (void) layoutSubviews{
    [super layoutSubviews];
    if (itemContentView.frame.size.width == self.frame.size.width) {
        return;
    }
    
    NSLog(@"layout");
    itemContentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    itemScrollView.delegate = nil;
    itemScrollView.frame = CGRectMake((self.frame.size.width - self.itemWidth)/2, 0, self.itemWidth, self.frame.size.height);
    itemScrollView.contentSize = CGSizeMake(itemCount * self.itemWidth, itemScrollView.frame.size.height);
    itemScrollView.contentOffset = CGPointMake(page * self.itemWidth, 0);
    
    for (int i = 0; i < ITEM_CACHECOUNT; i++) {
        ItemCell *itemCell = (ItemCell *)[itemArray objectAtIndex:i];
		NSInteger x = self.itemWidth * (itemCell.frame.origin.x / itemCell.frame.size.width);
		NSInteger y = 0;
		
        itemCell.frame = CGRectMake(x, y, self.itemWidth, itemScrollView.frame.size.height);
	}
    itemScrollView.delegate = self;
}
@end
