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

@interface ToyViewController : UIViewController<ItemViewDelegate,ScalableViewDelegate>{
@private
    ItemView *itemView;
    UIView *splitView;
    UILabel *titleLbl;
    UIImageView *navView;
    BOOL isMoreRequest;
    NSMutableArray *contentArray;
    UILabel *tipsLbl;
    UIButton *infoButton;
    TopIOSClient *iosClient;
    ScalableView *sortView;
    //UIWebView *infoView;
}

@property (nonatomic,assign) UILabel *titleLbl;

- (void) selectKeyword:(NSString *)keyword infoUrl:(NSString *)url;
@end
