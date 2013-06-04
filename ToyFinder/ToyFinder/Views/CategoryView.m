//
//  CategoryView.m
//  ToyFinder
//
//  Created by Wang Shuguang on 13-5-24.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "CategoryView.h"
#import <QuartzCore/QuartzCore.h>

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
        
        // 背景图
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgView.image = [UIImage stretchableImageWithPath:@"item_bg.png"];
        [self addSubview:bgView];
        [bgView release];
        
        // 
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
                NSDictionary *dict = [self.dataSource objectAtIndex:index];
                UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                imageButton.frame = CGRectMake((j + 1) * IMAGE_SPACE + j * imageWidth, (i + 1) * IMAGE_SPACE + i * imageWidth, imageWidth, imageWidth);
                [imageButton setImage:[UIImage noCacheImageNamed:[dict objectForKey:@"image"]] forState:UIControlStateNormal];
                [contentView addSubview:imageButton];
                imageButton.tag = index + IMAGE_TAG;
                [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                imageButton.layer.borderWidth = 1.0f;
                imageButton.layer.borderColor = RGBACOLOR(0, 0, 0, 0.6).CGColor;
                
                UILabel *tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(1, imageWidth - 14, imageWidth-2, 13)];
                tipsLbl.font = [UIFont systemFontOfSize:12.0f];
                tipsLbl.textColor = [UIColor whiteColor];
                tipsLbl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
                tipsLbl.textAlignment = UITextAlignmentCenter;
                [imageButton addSubview:tipsLbl];
                [tipsLbl release];
                tipsLbl.text = [dict objectForKey:@"name"];
                
                index++;
            }
        }
        
        contentView.contentSize = CGSizeMake(self.bounds.size.width, (yNum + 1) * IMAGE_SPACE + yNum * imageWidth);
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
