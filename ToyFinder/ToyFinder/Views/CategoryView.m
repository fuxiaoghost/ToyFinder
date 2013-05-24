//
//  CategoryView.m
//  ToyFinder
//
//  Created by Wang Shuguang on 13-5-24.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "CategoryView.h"

#define IMAGE_SPACE 10
#define IMAGE_NUM 4
#define IMAGE_TAG 1000

@interface CategoryView()
@property (nonatomic,retain) NSArray *dataSource;
@end

@implementation CategoryView
@synthesize delegate;

- (void) dealloc{
    self.dataSource = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame categorys:(NSArray *)categorys
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:contentView];
        [contentView release];
        
        self.dataSource = categorys;
        imageWidth = (frame.size.width - (IMAGE_NUM + 1) * IMAGE_SPACE + 0.0f)/IMAGE_NUM;
        
        NSInteger yNum = ceil(self.dataSource.count * 1.0/IMAGE_NUM);
        NSInteger xNum = IMAGE_NUM;
        NSInteger index = 0;
        for (int i = 0; i < yNum; i++) {
            for (int j = 0; j < xNum; j++) {
                if (index >= self.dataSource.count) {
                    break;
                }
                UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                imageButton.frame = CGRectMake((j + 1) * IMAGE_SPACE + j * imageWidth, (i + 1) * IMAGE_SPACE + i * imageWidth, imageWidth, imageWidth);
                imageButton.backgroundColor = [UIColor redColor];
                [contentView addSubview:imageButton];
                imageButton.tag = index + IMAGE_TAG;
                [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                index++;
            }
        }
    }
    return self;
}

- (void) imageButtonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    if ([delegate respondsToSelector:@selector(categoryView:didSelectedAtIndex:)]) {
        [delegate categoryView:self didSelectedAtIndex:button.tag - IMAGE_TAG];
    }
}

@end
