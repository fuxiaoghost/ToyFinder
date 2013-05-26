//
//  DetailPhotoCell.h
//  ToyFinder
//
//  Created by Dawn on 13-5-26.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailPhotoCell : UITableViewCell{
@private
    UIImageView *photoView;
    UIView *markView;
}
- (void) setPhoto:(NSString *)photo;
@end
