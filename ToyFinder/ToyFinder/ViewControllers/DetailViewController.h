//
//  DetailViewController.h
//  ToyFinder
//
//  Created by Dawn on 13-5-26.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullImageViewController.h"
#import "TBHttRequest.h"
#import "WallButton.h"

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FullImageViewControllerDelegate,TBHttRequestDelegate>{
@private
    UITableView *detailList;
    UITableView *photosList;
    TBHttRequest *detailRequest;
    UIView *titleBgView;
    UILabel *titleLbl;
    UIView *splitView;
    WallButton *closeButton;
    UIButton *buyButton;
    FullImageViewController *detailImageVC;
}
- (id) initWithTitle:(NSString *)title price:(NSString *)price_ promotion:(NSString *)promotion_ numIID:(NSString *)numIID;
@end
