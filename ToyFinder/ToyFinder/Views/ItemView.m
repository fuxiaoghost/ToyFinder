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
#define ITEM_WITH 240           // 单个Item的宽度
#define ITEM_CACHECOUNT 3       // 缓存容量
#define ITEM_TAG 2013
#define ITEM_SCALE  0.8         // 缩放大小

@implementation ItemView
@synthesize delegate;
@synthesize dataSource = _dataSource;

- (void) dealloc{
    self.dataSource = nil;
    [itemArray release];
    [super dealloc];
}


// 初始化图片
- (id)initWithFrame:(CGRect)frame dataSource:(NSArray *)ds{
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
        
        spage = 0;
        
        // item容器
        itemContentView = [[ItemContentView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:itemContentView];
        [itemContentView release];
        
        // item滚动翻页容器
        itemScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake((frame.size.width - ITEM_WITH)/2, 0, ITEM_WITH, itemContentView.frame.size.height)];
        itemScrollView.showsHorizontalScrollIndicator = NO;
        itemScrollView.showsVerticalScrollIndicator = NO;
        itemScrollView.tag = ITEM_TAG;
        itemScrollView.pagingEnabled = YES;
        itemScrollView.contentSize = CGSizeMake(itemCount * ITEM_WITH, itemScrollView.frame.size.height);
        itemScrollView.delegate = self;
        itemScrollView.clipsToBounds = NO;
        itemScrollView.backgroundColor = [UIColor blueColor];
        [itemContentView addSubview:itemScrollView];
        [itemScrollView release];
        
        // 页面中图片在内存中的容器
        itemArray = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < ITEM_CACHECOUNT && i < self.dataSource.count; i++) {
            NSInteger x = ITEM_WITH * i;
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
        
        [self layoutItemCells];
        
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
            NSInteger x = ITEM_WITH * i;
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
        
        [self layoutItemCells];
    }else{
        for (int i = 0; i < ITEM_CACHECOUNT; i++) {
            ItemCell *itemCell =  (ItemCell *)[itemArray objectAtIndex:i];
            NSInteger x = ITEM_WITH * i;
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

- (void) layoutItemCells{
    for (int i = 0; i < itemArray.count; i++) {
        ItemCell *itemCell =  (ItemCell *)[itemArray objectAtIndex:i];
        if (i == 0) {
            itemCell.contentTransform =  CGAffineTransformIdentity;
        }else if(i == 1){
            itemCell.contentTransform = CGAffineTransformScale(CGAffineTransformIdentity, ITEM_SCALE, ITEM_SCALE);
        }else{
            itemCell.contentTransform = CGAffineTransformScale(CGAffineTransformIdentity, ITEM_SCALE, ITEM_SCALE);
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
    
    itemCell.frame = CGRectMake(index * ITEM_WITH, 0, itemCell.frame.size.width, itemCell.frame.size.height);
    
    [self layoutItemCells];
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
    
    itemCell.frame = CGRectMake(index * ITEM_WITH, 0, itemCell.frame.size.width, itemCell.frame.size.height);
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
    
    itemCell.frame = CGRectMake(index * ITEM_WITH, 0, itemCell.frame.size.width, itemCell.frame.size.height);
}

#pragma mark -
#pragma mark Public Methods

// 翻到指定的页码
- (void) pageToIndex:(NSInteger)_index{
    if (_index == 0) {
        return;
    }else if(_index == 1){
        itemScrollView.contentOffset = CGPointMake(ITEM_WITH, 0);
    }else{
        for (int i = 0; i < _index + 1; i++) {
            page = i;
            [self photoPageDown];
        }
        itemScrollView.contentOffset = CGPointMake(ITEM_WITH * _index, 0);
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
    NSInteger rpage = floor((scrollView.contentOffset.x - scrollView.frame.size.width) / scrollView.frame.size.width + 1);
    float transformPercent = tpagef - rpage - 0.5;
    NSLog(@"%d",spage);
    
    if (spage == 0) {
        if (itemArray.count) {
            ItemCell *itemCell0 = [itemArray objectAtIndex:0];
            if(scrollView.contentOffset.x - scrollX > 0){
                itemCell0.contentTransform = CGAffineTransformMakeScale(1- (1-ITEM_SCALE) * transformPercent, 1- (1-ITEM_SCALE) * transformPercent);
            }
        }
      
        if (itemArray.count>=2) {
            ItemCell *itemCell1 = [itemArray objectAtIndex:1];
            if(scrollView.contentOffset.x - scrollX > 0){
                itemCell1.contentTransform = CGAffineTransformMakeScale(ITEM_SCALE + (1 - ITEM_SCALE) * transformPercent, ITEM_SCALE + (1 - ITEM_SCALE) * transformPercent);
            }
        }
    }else if (spage == itemCount - 1) {
        if (itemArray.count) {
            ItemCell *itemCell0 = [itemArray objectAtIndex:itemArray.count - 1];
            if(scrollView.contentOffset.x - scrollX < 0){
                itemCell0.contentTransform = CGAffineTransformMakeScale(1- (1-ITEM_SCALE) * transformPercent, 1- (1-ITEM_SCALE) * transformPercent);
            }
        }
        if (itemArray.count >=2) {
            ItemCell *itemCell1 = [itemArray objectAtIndex:itemArray.count - 2];
            if(scrollView.contentOffset.x - scrollX < 0){
                itemCell1.contentTransform = CGAffineTransformMakeScale(ITEM_SCALE + (1 - ITEM_SCALE) * transformPercent, ITEM_SCALE + (1 - ITEM_SCALE) * transformPercent);
            }
        }
    }else{
        ItemCell *itemCell0 = [itemArray objectAtIndex:0];
        if(scrollView.contentOffset.x - scrollX < 0){
            itemCell0.contentTransform = CGAffineTransformMakeScale(ITEM_SCALE + (1 - ITEM_SCALE) * transformPercent, ITEM_SCALE + (1 - ITEM_SCALE) * transformPercent);
        }
        
        ItemCell *itemCell1 = [itemArray objectAtIndex:1];
        itemCell1.contentTransform = CGAffineTransformMakeScale(1- (1-ITEM_SCALE) * transformPercent, 1- (1-ITEM_SCALE) * transformPercent);
        
        ItemCell *itemCell2 = [itemArray objectAtIndex:2];
        if(scrollView.contentOffset.x - scrollX > 0){
            itemCell2.contentTransform = CGAffineTransformMakeScale(ITEM_SCALE + (1 - ITEM_SCALE) * transformPercent, ITEM_SCALE + (1 - ITEM_SCALE) * transformPercent);
        }
    }
    
    
	
    if (tpage > page && tpage > 1 && tpage < itemCount - 1) {
        page = tpage;
        [self photoPageDown];
    }else if(tpage < page && tpage < itemCount - 2 && tpage > 0){
        page = tpage;
        [self photoPageUp];
    }else{
        page = tpage;
    }
    
    if ([delegate respondsToSelector:@selector(itemView:didPageToIndex:)]) {
        [delegate itemView:self didPageToIndex:page];
    }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    scrollX = scrollView.contentOffset.x;
    isDrag = YES;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    isDrag = NO;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    spage = page;
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
    itemScrollView.frame = CGRectMake((self.frame.size.width - ITEM_WITH)/2, 0, ITEM_WITH, self.frame.size.height);
    itemScrollView.contentSize = CGSizeMake(itemCount * ITEM_WITH, itemScrollView.frame.size.height);
    itemScrollView.contentOffset = CGPointMake(page * ITEM_WITH, 0);
    
    for (int i = 0; i < ITEM_CACHECOUNT; i++) {
        ItemCell *itemCell = (ItemCell *)[itemArray objectAtIndex:i];
		NSInteger x = ITEM_WITH * (itemCell.frame.origin.x / itemCell.frame.size.width);
		NSInteger y = 0;
		
        itemCell.frame = CGRectMake(x, y, ITEM_WITH, itemScrollView.frame.size.height);
	}
    itemScrollView.delegate = self;
}
@end
