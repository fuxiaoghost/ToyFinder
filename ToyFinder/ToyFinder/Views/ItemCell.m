//
//  ItemCell.m
//  ToyFinder
//
//  Created by Dawn on 13-5-19.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell
@synthesize contentTransform = _contentTransform;
@synthesize bgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, frame.size.width - 20, frame.size.height)];
        bgView.backgroundColor = RGBACOLOR(254, 246, 236, 1);
        [self addSubview:bgView];
        [bgView release];
    }
    return self;
}

- (CGAffineTransform) contentTransform{
    return _contentTransform;
}

- (void) setContentTransform:(CGAffineTransform)contentTransform{
    _contentTransform = contentTransform;
    bgView.transform = _contentTransform;
}

- (void) setFrame:(CGRect)frame{
    [super setFrame:frame];
    bgView.transform = CGAffineTransformIdentity;
    bgView.frame = CGRectMake(10, 0, frame.size.width - 20, self.frame.size.height);
    bgView.transform = _contentTransform;
}



@end
