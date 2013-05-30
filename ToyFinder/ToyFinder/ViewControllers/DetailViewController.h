//
//  DetailViewController.h
//  ToyFinder
//
//  Created by Dawn on 13-5-26.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullImageView.h"
#import "TBHttRequest.h"

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FullImageViewDelegate,TBHttRequestDelegate>{
@private
    UITableView *detailList;
    UITableView *photosList;
    TBHttRequest *detailRequest;
}
- (id) initWithTitle:(NSString *)title price:(NSString *)price_ promotion:(NSString *)promotion_ numIID:(NSString *)numIID;
@end
