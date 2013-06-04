//
//  FullInfoViewController.h
//  ToyFinder
//
//  Created by Dawn on 13-5-28.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "BaseViewController.h"
#import "WallButton.h"

@interface FullInfoViewController : BaseViewController<UIWebViewDelegate>{
    UIActivityIndicatorView *loadingView;
    WallButton *backButton;
    UIWebView *infoView;
}
@property (nonatomic,copy) NSString *fullInfo;
@property (nonatomic,copy) NSString *titleInfo;
@property (nonatomic,copy) NSString *navUrl;
@end
