//
//  CategoryViewController.h
//  ToyFinder
//
//  Created by Dawn on 13-5-18.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonWallView.h"

@interface CategoryViewController : UIViewController<ButtonWallViewDelegate>{
@private
    NSArray *buttonArray;
    ButtonWallView *buttonWall;
}

@end
