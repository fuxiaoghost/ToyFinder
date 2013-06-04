//
//  CityViewController.h
//  ToyFinder
//
//  Created by Dawn on 13-6-1.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "BaseViewController.h"
#import "WallButton.h"

@protocol CityViewControllerDelegate;
@interface CityViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
@private
    UITableView *cityList;
    NSArray *cityArray;
    NSArray *provinceArray;
    id delegate;
    UIView *filterView;
    UITextField *minPriceField;
    UITextField *maxPriceField;
    WallButton *closeButton;
    UISegmentedControl *filterSegment;
    UILabel *splitLbl;
    UIButton *actionBtn;
    WallButton *cancelBtn;
}
@property (nonatomic,assign) id<CityViewControllerDelegate> delegate;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,assign) NSInteger minPrice;
@property (nonatomic,assign) NSInteger maxPrice;
@end


@protocol CityViewControllerDelegate <NSObject>
@optional
- (void) cityViewController:(CityViewController *)cityViewController didSelectedCityName:(NSString *)cityName;
- (void) cityViewController:(CityViewController *)cityViewController didSetMinPrice:(NSInteger) minPrice maxPrice:(NSInteger) maxPrice;
@end