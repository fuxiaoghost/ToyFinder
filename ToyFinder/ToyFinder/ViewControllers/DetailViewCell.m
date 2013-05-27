//
//  HotelOrderCell.m
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DetailViewCell.h"

@implementation DetailViewCell
@synthesize cellType = _cellType;
@synthesize titleLbl;
@synthesize detailLbl;
@synthesize splitView;
@synthesize arrowView;

- (void) dealloc{
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [UIView setAnimationsEnabled:NO];
        
        // 背景色
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 44)];
        [self.contentView addSubview:bgImageView];
        [bgImageView release];
        
        // 分割线
        splitView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 43, SCREEN_WIDTH - 20, 1)];
        splitView.image = [UIImage stretchableImageWithPath:@"cell_split.png"];
        splitView.clipsToBounds = YES;
        splitView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:splitView];
        [splitView release];
        
        // 右侧指示箭头
        arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, (44 - 12)/2, 7, 12)];
        arrowView.image = [UIImage noCacheImageNamed:@"cell_indicator.png"];
        [self.contentView addSubview:arrowView];
        [arrowView release];
        
        // title
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 150, 50)];
        titleLbl.font = [UIFont systemFontOfSize:16.0f];
        titleLbl.adjustsFontSizeToFitWidth = YES;
        titleLbl.minimumFontSize = 12.0f;
        titleLbl.textColor = [UIColor colorWithRed:60.0/255.0f green:60.0/255.0f blue:60.0/255.0f alpha:1];
        titleLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:titleLbl];
        [titleLbl release];
        
        // detail
        detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 260, 50)];
        detailLbl.font = [UIFont boldSystemFontOfSize:16.0f];
        detailLbl.backgroundColor = [UIColor clearColor];
        detailLbl.adjustsFontSizeToFitWidth = YES;
        detailLbl.minimumFontSize = 12.0f;
        [self.contentView addSubview:detailLbl];
        [detailLbl release];
        
        [UIView setAnimationsEnabled:YES];
    }
    return self;
}

- (void) setCellType:(NSInteger)cellType{
    if (cellType == -1) {
        bgImageView.image = [UIImage stretchableImageWithPath:@"cell_header.png"];
        splitView.hidden = NO;
    }else if(cellType == 0){
        bgImageView.image = [UIImage stretchableImageWithPath:@"cell_middle.png"];
        splitView.hidden = NO;
    }else if(cellType == 1){
        bgImageView.image = [UIImage stretchableImageWithPath:@"cell_footer.png"];
        splitView.hidden = YES;
    }
    _cellType = cellType;
}

    

- (void) setSelected:(BOOL)selected animated:(BOOL)animated{
    //[super setSelected:selected animated:animated];
    
    if (arrowView.hidden) {
        selected = NO;
    }
    
    if (selected) {
        if (self.cellType == -1) {
            bgImageView.image = [UIImage stretchableImageWithPath:@"cell_header_h.png"];
        }else if(self.cellType == 0){
            bgImageView.image = [UIImage stretchableImageWithPath:@"cell_middle_h.png"];
        }else if(self.cellType == 1){
            bgImageView.image = [UIImage stretchableImageWithPath:@"cell_footer_h.png"];
        }
    }else{
        if (self.cellType == -1) {
            bgImageView.image = [UIImage stretchableImageWithPath:@"cell_header.png"];
        }else if(self.cellType == 0){
            bgImageView.image = [UIImage stretchableImageWithPath:@"cell_middle.png"];
        }else if(self.cellType == 1){
            bgImageView.image = [UIImage stretchableImageWithPath:@"cell_footer.png"];
        }
    }
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (arrowView.hidden) {
        highlighted = NO;
    }
    
    if (highlighted) {
        if (self.cellType == -1) {
            bgImageView.image = [UIImage stretchableImageWithPath:@"cell_header_h.png"];
        }else if(self.cellType == 0){
            bgImageView.image = [UIImage stretchableImageWithPath:@"cell_middle_h.png"];
        }else if(self.cellType == 1){
            bgImageView.image = [UIImage stretchableImageWithPath:@"cell_footer_h.png"];
        }
    }else{
        if (self.cellType == -1) {
            bgImageView.image = [UIImage stretchableImageWithPath:@"cell_header.png"];
        }else if(self.cellType == 0){
            bgImageView.image = [UIImage stretchableImageWithPath:@"cell_middle.png"];
        }else if(self.cellType == 1){
            bgImageView.image = [UIImage stretchableImageWithPath:@"cell_footer.png"];
        }
    }
}


@end
