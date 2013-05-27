//
//  HotelOrderCell.h
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewCell : UITableViewCell{
@private
    UIImageView *arrowView;
    UILabel *titleLbl;
    UILabel *detailLbl;
    UIImageView *bgImageView;
    UIImageView *splitView;
    UIImageView *creditView;
}
@property (nonatomic,assign) NSInteger cellType;
@property (nonatomic,readonly) UILabel *titleLbl;
@property (nonatomic,readonly) UILabel *detailLbl;
@property (nonatomic,readonly) UIImageView *splitView;
@property (nonatomic,readonly) UIImageView *arrowView;
@property (nonatomic,readonly) UIImageView *creditView;
@end
