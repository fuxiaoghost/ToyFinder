//
//  ItemContentView.m
//  ToyFinder
//
//  Created by Dawn on 13-5-19.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "ItemContentView.h"
#define ITEM_TAG 2013

@implementation ItemContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
	UIView *subView = [self viewWithTag:ITEM_TAG];
    
    if (subView) {
        if (point.y>subView.frame.size.height) {
            return [super hitTest:point withEvent:event];
        }
        if (point.x>=subView.frame.origin.x&&point.x<=subView.frame.origin.x+subView.frame.size.width) {
            return [super hitTest:point withEvent:event];
        }
        return subView;
    }
    return self;
}

@end
