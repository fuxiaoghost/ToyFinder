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
        
        float x = 0;
        float y = 0;
        for(int i = 0;i < self.dataSource.count;i++) {
            NSDictionary *dict = [self.dataSource objectAtIndex:i];
            NSString *name = [dict objectForKey:@"name"];
            WallButton *button = [WallButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            if (x + BUTTON_WIDTH * name.length + 10> frame.size.width) {
                y += 40 + 10;
                x = 0;
            }
            button.frame = CGRectMake(x, y, name.length * BUTTON_WIDTH, 40);
            [button setTitle:name forState:UIControlStateNormal];
            [contentView addSubview:button];
            x += (10 + name.length * BUTTON_WIDTH);
            button.tag = BUTTON_TAG + i;
            
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        contentView.contentSize = CGSizeMake(frame.size.width, y + 40 + 10);
    }
    return self;
}

- (void) buttonClick:(id)sender{
    
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
