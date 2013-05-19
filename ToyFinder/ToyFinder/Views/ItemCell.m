//
//  ItemCell.m
//  ToyFinder
//
//  Created by Dawn on 13-5-19.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "ItemCell.h"
#define ITEM_WITH 240

@implementation ItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ITEM_WITH - 20, frame.size.height)];
        bgView.backgroundColor = [UIColor redColor];
        [self addSubview:bgView];
        [bgView release];
    }
    return self;
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
    bgView.frame = CGRectMake(10, 0, ITEM_WITH - 20, self.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
