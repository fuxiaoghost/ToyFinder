//
//  RootViewController.h
//  ToyFinder
//
//  Created by Dawn on 13-5-18.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemView.h"
#import "TBHttRequest.h"
#import "SlideDownView.h"

@interface ToyViewController : UIViewController<ItemViewDelegate,TBHttRequestDelegate,SlideDownViewDelegate>{
@private
    ItemView *itemView;
    UIView *splitView;
    UIImageView *navView;
    NSMutableArray *contentArray;
    UILabel *tipsLbl;
    UIButton *infoButton;
    TBHttRequest *request;
    UIView *navBgView;
    UIButton *filterBtn;
}


- (void) selectKeyword:(NSString *)keyword infoUrl:(NSString *)url;
@end
