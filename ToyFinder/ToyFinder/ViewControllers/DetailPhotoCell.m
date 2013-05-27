//
//  DetailPhotoCell.m
//  ToyFinder
//
//  Created by Dawn on 13-5-26.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "DetailPhotoCell.h"
#import "UIImageView+WebCache.h"

@implementation DetailPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 192, 192)];
        bgView.image = [UIImage stretchableImageWithPath:@"item_bg.png"];
        [self.contentView addSubview:bgView];
        [bgView release];
        
        photoView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 180, 180)];
        [bgView addSubview:photoView];
        photoView.contentMode = UIViewContentModeScaleAspectFill;
        [photoView release];
        
        
        CGAffineTransform transform =  CGAffineTransformMakeRotation(M_PI_2);
        bgView.transform = transform;
        bgView.frame = CGRectMake(4, 4, 192 ,192);
        
        markView = [[UIView alloc] initWithFrame:CGRectMake(6, 6, 180, 180)];
        markView.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);
        [bgView addSubview:markView];
        [markView release];
        markView.hidden = YES;
    }
    return self;
}

- (void) setPhoto:(NSString *)photo{
    NSLog(@"%@",photo);
    [photoView setImageWithURL:[NSURL URLWithString:photo] placeholderImage:nil options:SDWebImageLowPriority];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
//    if (selected) {
//        markView.hidden = NO;
//    }else{
//        markView.hidden = YES;
//    }
    markView.hidden = YES;
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        markView.hidden = NO;
    }else{
        markView.hidden = YES;
    }
}

@end
