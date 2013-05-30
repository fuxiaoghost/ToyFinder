//
//  RootViewController.h
//  ToyFinder
//
//  Created by Dawn on 13-5-18.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemView.h"
#import "ScalableView.h"
#import "TBHttRequest.h"

@interface ToyViewController : UIViewController<ItemViewDelegate,ScalableViewDelegate,TBHttRequestDelegate>{
@private
    ItemView *itemView;
    UIView *splitView;
    UILabel *titleLbl;
    UIImageView *navView;
    NSMutableArray *contentArray;
    UILabel *tipsLbl;
    UIButton *infoButton;
    TBHttRequest *request;
    ScalableView *sortView;
}

@property (nonatomic,assign) UILabel *titleLbl;

- (void) selectKeyword:(NSString *)keyword infoUrl:(NSString *)url;
@end
