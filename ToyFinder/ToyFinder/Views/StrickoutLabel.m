//
//  StrickoutLabel.m
//  Elong_Shake
//
//  Created by Wang Shuguang on 13-2-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "StrickoutLabel.h"

@implementation StrickoutLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    //CGFloat red[4] = {1.0f,0.0f, 0.0f,0.8f}; //红色
    //CGFloat black[4] = {0.0f, 0.0f, 0.0f, 0.5f};//黑色
    CGContextSetStrokeColorWithColor(c, self.textColor.CGColor);
    CGContextSetLineWidth(c, 1.5);
    CGContextBeginPath(c);
    
    float fontWidth = [self.text sizeWithFont:self.font].width;
    float fontHeight = 4;//[self.text sizeWithFont:self.font].height;
    
    //画直线
    CGFloat halfWayUp = rect.size.height/2 + rect.origin.y;
    CGContextMoveToPoint(c, rect.origin.x - 6, halfWayUp - fontHeight/2);//halfWayUp );//开始点
    CGContextAddLineToPoint(c, rect.origin.x + fontWidth + 3, halfWayUp + fontHeight/2);//结束点
    CGContextStrokePath(c);
    
    [super drawRect:rect];
}


@end
