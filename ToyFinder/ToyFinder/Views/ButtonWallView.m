//
//  ButtonWallView.m
//  ToyFinder
//
//  Created by Wang Shuguang on 13-5-21.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "ButtonWallView.h"
#import "WallButton.h"

#define BUTTON_TAG 1000
#define BUTTON_WIDTH 14
#define BUTTON_HEIGHT 30

@interface ButtonWallView()
@property (nonatomic,retain) NSArray *dataSource;
@end

@implementation ButtonWallView
@synthesize delegate;

- (void) dealloc{
    
    self.dataSource = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame buttons:(NSArray *)buttons
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.dataSource = buttons;
        
        contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:contentView];
        [contentView release];
        
        [self reloadData];
    }
    return self;
}

- (void) reloadData{
    float x = 10;
    float y = 10;
    for(int i = 0;i < self.dataSource.count;i++) {
        NSDictionary *dict = [self.dataSource objectAtIndex:i];
        NSString *name = [dict objectForKey:@"name"];
        
        CGSize size = [name sizeWithFont:[UIFont systemFontOfSize:12.0f]];
        NSInteger buttonWidth = size.width + 10;
        WallButton *button = [WallButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        
        if (x + buttonWidth + 10> self.frame.size.width) {
            y += BUTTON_HEIGHT + 4;
            x = 10;
        }
        button.frame = CGRectMake(x, y, buttonWidth, BUTTON_HEIGHT);
        [button setTitle:name forState:UIControlStateNormal];
        [button setTitleColor:RGBACOLOR(221, 70, 0, 1) forState:UIControlStateNormal];
        [button setTitleColor:RGBACOLOR(255, 255, 255, 1) forState:UIControlStateHighlighted];
        [contentView addSubview:button];
        x += (10 + buttonWidth);
        button.tag = BUTTON_TAG + i;
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    contentView.contentSize = CGSizeMake(self.frame.size.width, y + BUTTON_HEIGHT + 10);
}

- (void) buttonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    if ([self.delegate respondsToSelector:@selector(didClickButton:atIndex:)]) {
        [self.delegate didClickButton:button atIndex:button.tag - BUTTON_TAG];
    }
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
    contentView.frame = self.bounds;
    for (UIView *button in contentView.subviews) {
        [button removeFromSuperview];
    }
    
    [self reloadData];
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
