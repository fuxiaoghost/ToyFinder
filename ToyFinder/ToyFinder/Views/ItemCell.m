//
//  ItemCell.m
//  ToyFinder
//
//  Created by Dawn on 13-5-19.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "ItemCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

@implementation ItemCell
@synthesize contentTransform = _contentTransform;
@synthesize bgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // 背景
        bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgView.image = [UIImage stretchableImageWithPath:@"item_bg.png"];
        [self addSubview:bgView];
        [bgView release];
        
        
        // 图片
        photoView  = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, bgView.frame.size.width - 12, bgView.frame.size.height - 12)];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        photoView.clipsToBounds = YES;
        [bgView addSubview:photoView];
        [photoView release];
        
        // 标题
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, photoView.frame.size.width, 0)];
        titleLbl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [titleLbl setFont:[UIFont systemFontOfSize:14.0f]];
        titleLbl.lineBreakMode = UILineBreakModeCharacterWrap;
        titleLbl.numberOfLines = 0;
        titleLbl.textColor = [UIColor whiteColor];
        [photoView addSubview:titleLbl];
        [titleLbl release];
        
        // 价格
        priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, photoView.frame.size.width, 0)];
        priceLbl.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        [priceLbl setFont:[UIFont systemFontOfSize:14.0f]];
        priceLbl.textColor = RGBACOLOR(221, 70, 0, 1);
        priceLbl.textAlignment = UITextAlignmentCenter;
        [photoView addSubview:priceLbl];
        [priceLbl release];
    }
    return self;
}

- (void) setTitle:(NSString *)title{
    CGSize size = CGSizeMake(photoView.frame.size.width, 10000);
    CGSize newSize = [title sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    titleLbl.text = title;
    titleLbl.frame = CGRectMake(0, photoView.frame.size.height - newSize.height - 20, photoView.frame.size.width, newSize.height + 20);
}

- (void) setPrice:(NSString *)price{
    priceLbl.frame = CGRectMake(photoView.frame.size.width - 60, 0, 60, 20);
    priceLbl.text = price;
}

- (void) setPhoto:(NSString *)photo{
    [photoView setImageWithURL:[NSURL URLWithString:photo] placeholderImage:nil];
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
    bgView.frame = CGRectMake(0, 0, frame.size.width, self.frame.size.height);
    bgView.transform = _contentTransform;
    photoView.frame = CGRectMake(6, 6, frame.size.width - 12, self.frame.size.height - 12);
    
    [self setTitle:[NSString stringWithFormat:@"%@",titleLbl.text]];
    
    priceLbl.frame = CGRectMake(photoView.frame.size.width - 60, 0, 60, 20);
}



@end
