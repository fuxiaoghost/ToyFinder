//
//  ItemCell.h
//  ToyFinder
//
//  Created by Dawn on 13-5-19.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCell : UIView{
@private
    UIImageView *bgView;
    UIImageView *photoView;
    UILabel *titleLbl;
    UILabel *priceLbl;
    UILabel *volumeLbl;
}
@property (nonatomic,assign) CGAffineTransform contentTransform;
@property (nonatomic,readonly) UIView *bgView;

- (void) setPhoto:(NSString *)photo;
- (void) setTitle:(NSString *)title;
- (void) setPrice:(NSString *)price;
@end
