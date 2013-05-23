//
//  RootViewController.h
//  ToyFinder
//
//  Created by Dawn on 13-5-18.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemView.h"

@interface ToyViewController : UIViewController<ItemViewDelegate>{
@private
    ItemView *itemView;
    UIView *splitView;
    UILabel *titleLbl;
    UIImageView *navView;
    BOOL isMoreRequest;
    NSMutableArray *contentArray;
    UILabel *tipsLbl;
}

@property (nonatomic,assign) UILabel *titleLbl;

- (void) selectCategoryDict:(NSDictionary *)dict;
@end
