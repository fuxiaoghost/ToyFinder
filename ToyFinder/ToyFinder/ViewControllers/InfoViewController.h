//
//  InfoViewController.h
//  ToyFinder
//
//  Created by Dawn on 13-5-26.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WallButton.h"

@interface InfoViewController : BaseViewController{
@private
    UIWebView *infoView;
    WallButton *closeButton;
}
- (id) initWithUrl:(NSString *)url_ title:(NSString *)title_;
@end
