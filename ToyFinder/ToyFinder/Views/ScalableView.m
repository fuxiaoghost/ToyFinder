//
//  ScalableView.m
//  ElongClient
//
//  弹出式菜单选择控件
//
//  Created by Wang Shuguang on 12-12-11.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import "ScalableView.h"
#import <QuartzCore/QuartzCore.h>

#define SCALABLEBUTTONTAG 1010
@implementation ScalableView
@synthesize delegate;
@synthesize imageArray;
@synthesize hightlightedArray;

- (void) dealloc{
    [buttons release];
    self.imageArray = nil;
    self.hightlightedArray = nil;
    [super dealloc];
}

// 
- (id)initWithFrame:(CGRect)frame
             images:(NSArray *)images                   // 正常图标
  highlightedImages:(NSArray *)hImages                  // 高亮图标
          direction:(ScalableDirection)direction_       // 弹出方向
         firstSpace:(NSInteger)firstSpace{              // 菜单首项的间距
    self = [super initWithFrame:frame];
    if (self) {
        self.imageArray = images;
        self.hightlightedArray = hImages;
        // Initialization code
        buttons = [[NSMutableArray alloc] initWithCapacity:[images count]];
        buttonSize = CGSizeMake(frame.size.height, frame.size.height);
        buttonCount = [images count];
        firstButtonSpace = firstSpace;
        buttonSpace = (frame.size.width - buttonSize.width + 0.0 - firstButtonSpace)/(buttonCount - 1 - 1);
        expand = NO;
        frameTime = 0.8/(buttonCount - 1);
        bounceSpace = 16;
        direction = direction_;
        for (int i = 0; i < [images count]; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.exclusiveTouch = YES;
            if (direction == FromLeftToRight) {
                button.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
            }else{
                button.frame = CGRectMake(frame.size.width - buttonSize.width, 0, buttonSize.width, buttonSize.height);
            }
            
            [button setImage:[UIImage noCacheImageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
            if (hImages && [hImages count] > i) {
                [button setImage:[UIImage noCacheImageNamed:[hImages objectAtIndex:i]] forState:UIControlStateHighlighted];
            }
            [self addSubview:button];
            [buttons addObject:button];
            button.tag = i + SCALABLEBUTTONTAG;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setAdjustsImageWhenDisabled:NO];
        }
        
        lastIndex = -1;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
             images:(NSArray *)images               // 正常图标
  highlightedImages:(NSArray *)hImages              // 高亮图标
          direction:(ScalableDirection)direction_{  // 弹出方向
    return [self initWithFrame:frame images:images highlightedImages:hImages direction:direction_ firstSpace:70];
}


// 收回弹出菜单
- (void) moveBack{
    if (expand) {
        int index = imageArray.count - 1;
        UIButton *button = (UIButton *)[self viewWithTag:index + SCALABLEBUTTONTAG];
        [button setImage:[UIImage noCacheImageNamed:[self.imageArray objectAtIndex:index]] forState:UIControlStateNormal];
        [self beginAnimation];
    }
}

- (void) buttonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    if (lastIndex != imageArray.count - 1 && lastIndex != -1) {
        UIButton *lastButton = (UIButton *)[self viewWithTag:lastIndex + SCALABLEBUTTONTAG];
        [lastButton setImage:[UIImage noCacheImageNamed:[self.imageArray objectAtIndex:lastIndex]] forState:UIControlStateNormal];
    }
    lastIndex = button.tag - SCALABLEBUTTONTAG;
    if (lastIndex != imageArray.count - 1 && lastIndex != -1) {
        [button setImage:[UIImage noCacheImageNamed:[self.hightlightedArray objectAtIndex:lastIndex]] forState:UIControlStateNormal];
    }
    
    if (lastIndex == imageArray.count - 1) {
        if (!expand) {
            [button setImage:[UIImage noCacheImageNamed:[self.hightlightedArray objectAtIndex:lastIndex]] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage noCacheImageNamed:[self.imageArray objectAtIndex:lastIndex]] forState:UIControlStateNormal];
        }
    }

    
    if (button.tag-SCALABLEBUTTONTAG == buttonCount - 1) {
        // 最上层的触发按钮
        [self beginAnimation];
        if ([delegate respondsToSelector:@selector(scalableViewDidMoveout:)]) {
            [delegate scalableViewDidMoveout:self];
        }
    }else{
        if ([delegate respondsToSelector:@selector(scalableView:didSelectedAtIndex:)]) {
            [delegate scalableView:self didSelectedAtIndex:button.tag - SCALABLEBUTTONTAG];
        }
    }
}


// 碰撞测试，控件所有的空隙均不能接受用户行为
#pragma mark -
#pragma mark HitTest
-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIButton *baseButton =  (UIButton *)[self viewWithTag:SCALABLEBUTTONTAG + buttonCount - 1];
    if (point.x > baseButton.frame.origin.x
        && point.x < baseButton.frame.origin.x + baseButton.frame.size.width
        && point.y > baseButton.frame.origin.y
        && point.y < baseButton.frame.origin.y + baseButton.frame.size.height) {
        return baseButton;
    }
    
    for (int i = 0; i < buttonCount-1; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:SCALABLEBUTTONTAG + i];
        if (point.x > button.frame.origin.x
            && point.x < button.frame.origin.x + button.frame.size.width
            && point.y > button.frame.origin.y
            && point.y < button.frame.origin.y + button.frame.size.height) {
            return button;
        }
    }
    
    return nil;
}

// 控件的动画
- (void) beginAnimation{
   
    if (!expand) {
        expand = YES;
        
        CGPoint startPoint;
        CGPoint endPoint;
        for (int i = 0; i < buttonCount - 1; i++) {
            if (direction == FromLeftToRight) {
                startPoint = CGPointMake(0 + buttonSize.width/2, buttonSize.width/2);
                endPoint = CGPointMake(startPoint.x + (buttonCount - i - 1 - 1) * buttonSpace + firstButtonSpace, buttonSize.width/2);
            }else{
                startPoint = CGPointMake(self.frame.size.width - buttonSize.width/2, buttonSize.width/2);
                endPoint = CGPointMake(startPoint.x - (buttonCount - i - 1 - 1) * buttonSpace - firstButtonSpace, buttonSize.width/2);
            }
           
            
            UIButton *button = (UIButton *)[buttons objectAtIndex:i];
            
            // 旋转
            float duration = (buttonCount - i - 1) * frameTime;
            CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
            if (direction == FromLeftToRight) {
                rotateAnimation.values = [NSArray arrayWithObjects:
                                          [NSNumber numberWithFloat:0],
                                          [NSNumber numberWithFloat:M_PI],
                                          [NSNumber numberWithFloat:M_PI * 2], nil];
            }else{
                rotateAnimation.values = [NSArray arrayWithObjects:
                                          [NSNumber numberWithFloat:0],
                                          [NSNumber numberWithFloat:-M_PI],
                                          [NSNumber numberWithFloat:-M_PI * 2], nil];
            }
           
            rotateAnimation.duration = duration;
            rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                        [NSNumber numberWithFloat:0],
                                        [NSNumber numberWithFloat:duration * 1/2],
                                        [NSNumber numberWithFloat:duration], nil];
            
            
            // 按轨迹移动
            CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
            for (int j = 0; j < buttonCount - 1 - i; j++) {
                if (j == buttonCount - 1 - i - 1) {
                    if (direction == FromLeftToRight) {
                        CGPathAddLineToPoint(path, NULL, startPoint.x + (buttonCount - 1 - i - 1) * buttonSpace + firstButtonSpace + bounceSpace, startPoint.y);
                    }else{
                        CGPathAddLineToPoint(path, NULL, startPoint.x - (buttonCount - 1 - i - 1) * buttonSpace - firstButtonSpace - bounceSpace, startPoint.y);
                    }
                    
                }else{
                    if (direction == FromLeftToRight) {
                        CGPathAddLineToPoint(path, NULL, startPoint.x + (j + 1 - 1) * buttonSpace + firstButtonSpace, startPoint.y);
                    }else{
                        CGPathAddLineToPoint(path, NULL, startPoint.x - (j + 1 - 1) * buttonSpace - firstButtonSpace, startPoint.y);
                    }
                }
            }
            if (FromLeftToRight == direction) {
                 CGPathAddLineToPoint(path, NULL, startPoint.x + (buttonCount - 1 - i - 1) * buttonSpace + firstButtonSpace, startPoint.y);
            }else{
                 CGPathAddLineToPoint(path, NULL, startPoint.x - (buttonCount - 1 - i - 1) * buttonSpace - firstButtonSpace, startPoint.y);
            }
           
            
            positionAnimation.path = path;
            CGPathRelease(path);
            positionAnimation.duration = duration;
            
            
            CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
            if (IOSVersion_5) {
                animationgroup.animations = [NSArray arrayWithObjects:rotateAnimation,positionAnimation, nil];
            }else{
                animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, nil];
            }
            
            animationgroup.duration = duration;
            animationgroup.fillMode = kCAFillModeForwards;
            animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [button.layer addAnimation:animationgroup forKey:@"out"];
            button.center = endPoint;
        }
       
    }else{
        expand = NO;
        CGPoint endPoint;
        CGPoint startPoint;
        for (int i = 0; i < buttonCount - 1; i++) {
            if (FromLeftToRight == direction) {
                endPoint = CGPointMake(0 + buttonSize.width/2, buttonSize.width/2);
                startPoint = CGPointMake(endPoint.x + (buttonCount - i - 1 - 1) * buttonSpace + firstButtonSpace, buttonSize.width/2);
            }else{
                endPoint = CGPointMake(self.frame.size.width - buttonSize.width/2, buttonSize.width/2);
                startPoint = CGPointMake(endPoint.x - (buttonCount - i - 1 - 1) * buttonSpace - firstButtonSpace, buttonSize.width/2);
            }
            
            
            UIButton *button = (UIButton *)[buttons objectAtIndex:i];
            
            // 旋转
            float duration = (buttonCount - i - 1) * frameTime;
            CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
            if (FromLeftToRight == direction) {
                rotateAnimation.values = [NSArray arrayWithObjects:
                                          [NSNumber numberWithFloat:0],
                                          [NSNumber numberWithFloat:-M_PI],
                                          [NSNumber numberWithFloat:-M_PI * 2], nil];
            }else{
                rotateAnimation.values = [NSArray arrayWithObjects:
                                          [NSNumber numberWithFloat:0],
                                          [NSNumber numberWithFloat:M_PI],
                                          [NSNumber numberWithFloat:M_PI * 2], nil];
            }
            
            rotateAnimation.duration = duration;
            rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                        [NSNumber numberWithFloat:0],
                                        [NSNumber numberWithFloat:duration * 1/2],
                                        [NSNumber numberWithFloat:duration], nil];
            
            // 按轨迹移动
            CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
            if (FromLeftToRight == direction) {
                CGPathAddLineToPoint(path, NULL, startPoint.x + bounceSpace/2, startPoint.y);
            }else{
                CGPathAddLineToPoint(path, NULL, startPoint.x - bounceSpace/2, startPoint.y);
            }
            
            for (int j = 0; j < buttonCount - 1 - i; j++) {
                if (FromLeftToRight == direction) {
                    CGPathAddLineToPoint(path, NULL, startPoint.x - (j + 1 - 1) * buttonSpace - firstButtonSpace, startPoint.y);
                }else{
                    CGPathAddLineToPoint(path, NULL, startPoint.x + (j + 1 - 1) * buttonSpace + firstButtonSpace, startPoint.y);
                }
                
            }
            //CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
            positionAnimation.path = path;
            CGPathRelease(path);
            positionAnimation.duration = (buttonCount - i - 1) * frameTime;
            
            
            CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
            animationgroup.animations = [NSArray arrayWithObjects:rotateAnimation,positionAnimation, nil];
            animationgroup.duration = duration;
            animationgroup.speed = 2;
            animationgroup.fillMode = kCAFillModeForwards;
            animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [button.layer addAnimation:animationgroup forKey:@"in"];
            button.center = endPoint;

        }
    }
   
}
@end
