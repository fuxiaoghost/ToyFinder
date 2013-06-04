//
//  CityViewController.m
//  ToyFinder
//
//  Created by Dawn on 13-6-1.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "CityViewController.h"
#import "WallButton.h"
#import "AppDelegate.h"
#import "SlideViewController.h"

@interface CityViewController ()

@end

@implementation CityViewController
@synthesize delegate;
@synthesize city;
@synthesize minPrice;
@synthesize maxPrice;

- (void) dealloc{
    [cityArray release];
    [provinceArray release];
    self.city = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSDictionary *cityDict = [NSDictionary dictionaryWithContentsOfFile:RESOURCEFILE(@"Citys", @"plist")];
    cityArray = [[NSArray alloc] initWithArray:[cityDict objectForKey:@"city"]];
    provinceArray = [[NSArray alloc] initWithArray:[cityDict objectForKey:@"province"]];
    
    self.title = @"筛选";
    
    closeButton = [WallButton buttonWithType:UIButtonTypeCustom];
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        closeButton.frame = CGRectMake(SCREEN_WIDTH - 60, 5, 50, 35);
    }else{
        closeButton.frame = CGRectMake(SCREEN_HEIGHT - 60, 5, 50, 35);
    }
    
    [closeButton setTitle:@"完成" forState:UIControlStateNormal];
    [closeButton setTitleColor:RGBACOLOR(221, 70, 0, 1) forState:UIControlStateNormal];
    [closeButton setTitleColor:RGBACOLOR(255, 255, 255, 1) forState:UIControlStateHighlighted];
    [self.view addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.city) {
        filterSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"筛选",self.city, nil]];
    }else{
        filterSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"筛选",@"所有地区", nil]];
    }
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        filterSegment.frame = CGRectMake(80, 4, SCREEN_WIDTH - 160, 36);
    }else{
        filterSegment.frame = CGRectMake(80, 4, SCREEN_HEIGHT - 160, 36);
    }
    
    filterSegment.segmentedControlStyle = UISegmentedControlStyleBar;
    filterSegment.tintColor = RGBACOLOR(245,124,0,1);
    [self.view addSubview:filterSegment];
    [filterSegment release];
    filterSegment.selectedSegmentIndex = 0;
    [filterSegment addTarget:self action:@selector(filterSegmentIndexChange:) forControlEvents:UIControlEventValueChanged];
    
    /*
     UISegmentedControlStylePlain,     // large plain
     UISegmentedControlStyleBordered,  // large bordered
     UISegmentedControlStyleBar,       // small button/nav bar style. tintable
     UISegmentedControlStyleBezeled,   // DEPRECATED. Do not use this style.
     */
    
    // 所在地
    if(LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN){
        cityList = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45) style:UITableViewStylePlain];
    }else{
        cityList = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_HEIGHT, SCREEN_WIDTH - 45) style:UITableViewStylePlain];
    }
    cityList.delegate = self;
    cityList.dataSource = self;
    cityList.rowHeight = 40;
    [self.view addSubview:cityList];
    [cityList release];
    cityList.separatorColor =  RGBACOLOR(240, 240, 240, 1);
    
    
    // 筛选
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45)];
    }else{
        filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_HEIGHT, SCREEN_WIDTH - 45)];
    }
    
    filterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:filterView];
    [filterView release];
    
    // 价格区间
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        minPriceField = [[UITextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, 60, 80, 36)];
    }else{
        minPriceField = [[UITextField alloc] initWithFrame:CGRectMake((SCREEN_HEIGHT - 200)/2, 60, 80, 36)];
    }
    
    minPriceField.keyboardType = UIKeyboardTypeNumberPad;
    minPriceField.borderStyle = UITextBorderStyleRoundedRect;
    minPriceField.placeholder = @"元";
    minPriceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [filterView addSubview:minPriceField];
    [minPriceField release];
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        maxPriceField = [[UITextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2 + 80 + 40, 60, 80, 36)];
    }else{
        maxPriceField = [[UITextField alloc] initWithFrame:CGRectMake((SCREEN_HEIGHT - 200)/2 + 80 + 40, 60, 80, 36)];
    }
    
    maxPriceField.keyboardType = UIKeyboardTypeNumberPad;
    maxPriceField.borderStyle = UITextBorderStyleRoundedRect;
    maxPriceField.placeholder = @"元";
    maxPriceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [filterView addSubview:maxPriceField];
    [maxPriceField release];
    
  
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        splitLbl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2 + 80, 60, 40, 36)];
    }else{
        splitLbl = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_HEIGHT - 200)/2 + 80, 60, 40, 36)];
    }
    
    splitLbl.font = [UIFont systemFontOfSize:14.0f];
    splitLbl.textAlignment = UITextAlignmentCenter;
    splitLbl.textColor = [UIColor grayColor];
    [filterView addSubview:splitLbl];
    [splitLbl release];
    splitLbl.text = @"~";
    
    actionBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        actionBtn.frame = CGRectMake(SCREEN_WIDTH - 80, 140, 60, 30);
    }else{
        actionBtn.frame = CGRectMake(SCREEN_HEIGHT - 80, 140, 60, 30);
    }
    
    actionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [actionBtn setTitle:@"确定" forState:UIControlStateNormal];
    [actionBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"action_bg.png"] forState:UIControlStateNormal];
    [actionBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"action_bg_h.png"] forState:UIControlStateHighlighted];
    [filterView addSubview:actionBtn];
    [actionBtn addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelBtn = [WallButton buttonWithType:UIButtonTypeCustom];
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        cancelBtn.frame = CGRectMake(SCREEN_WIDTH - 160, 140, 60, 30);
    }else{
        cancelBtn.frame = CGRectMake(SCREEN_HEIGHT - 160, 140, 60, 30);
    }
    [cancelBtn setTitle:@"重置" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGBACOLOR(221, 70, 0, 1) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGBACOLOR(255, 255, 255, 1) forState:UIControlStateHighlighted];
    [filterView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.minPrice) {
        minPriceField.text = [NSString stringWithFormat:@"%d",self.minPrice];
    }
    if (self.maxPrice) {
        maxPriceField.text =  [NSString stringWithFormat:@"%d",self.maxPrice];
    }
    
    [minPriceField becomeFirstResponder];
    
}

- (void) cancelButtonClick:(id)sender{
    minPriceField.text = @"";
    maxPriceField.text = @"";
    self.minPrice = 0;
    self.maxPrice = 0;
}

- (void) actionButtonClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
    
    self.minPrice = [minPriceField.text intValue];
    self.maxPrice = [maxPriceField.text intValue];
    if (minPrice > maxPrice) {
        NSInteger tprice = minPrice;
        minPrice = maxPrice;
        maxPrice = tprice;
    }
    if ([delegate respondsToSelector:@selector(cityViewController:didSetMinPrice:maxPrice:)]) {
        [delegate cityViewController:self didSetMinPrice:minPrice maxPrice:maxPrice];
    }
}

- (void) closeButtonClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) filterSegmentIndexChange:(id)sender{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    if (segment.selectedSegmentIndex == 0) {
        filterView.hidden = NO;
        cityList.hidden = YES;
        [minPriceField becomeFirstResponder];
    }else if(segment.selectedSegmentIndex == 1){
        filterView.hidden = YES;
        cityList.hidden = NO;
        [minPriceField resignFirstResponder];
        [maxPriceField resignFirstResponder];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return cityArray.count;
    }else if(section == 2){
        return provinceArray.count;
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"CityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.highlightedTextColor = [UIColor grayColor];
        cell.backgroundColor = RGBACOLOR(250, 250, 250, 0.4);
        
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        selectView.backgroundColor = RGBACOLOR(240, 240, 240, 1);
        cell.selectedBackgroundView = selectView;
        [selectView release];
        
    
        
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"    所有区域";
    }else if (indexPath.section == 1){
        cell.textLabel.text = [NSString stringWithFormat:@"    %@",[[cityArray objectAtIndex:indexPath.row] objectForKey:@"city_name"]];
    }else if (indexPath.section == 2){
        cell.textLabel.text = [NSString stringWithFormat:@"    %@",[[provinceArray objectAtIndex:indexPath.row] objectForKey:@"city_name"]];
    }
    return cell;
}
#pragma mark -
#pragma mark UITableViewDelegate

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    sectionLbl.backgroundColor = RGBACOLOR(250, 250, 250, 1);
    sectionLbl.font = [UIFont systemFontOfSize:14.0f];
    sectionLbl.textColor = [UIColor lightGrayColor];
    if (section == 1) {
        sectionLbl.text = @"    城市";
    }else if(section == 2){
        sectionLbl.text = @"    省份";
    }
    return [sectionLbl autorelease];
}

- (float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if(section == 1){
        return 20;
    }else if(section == 2){
        return 20;
    }
    return 0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissModalViewControllerAnimated:YES];
    
    if ([delegate respondsToSelector:@selector(cityViewController:didSelectedCityName:)]) {
        if (indexPath.section == 0) {
            self.city = nil;
            [delegate cityViewController:self didSelectedCityName:nil];
        }else if(indexPath.section == 1){
            NSString *cityName = [NSString stringWithFormat:@"%@",[[cityArray objectAtIndex:indexPath.row] objectForKey:@"city_name"]];
            self.city = cityName;
            [delegate cityViewController:self didSelectedCityName:cityName];
        }else if(indexPath.section == 2){
            NSString *cityName = [NSString stringWithFormat:@"%@",[[provinceArray objectAtIndex:indexPath.row] objectForKey:@"city_name"]];
            self.city = cityName;
            [delegate cityViewController:self didSelectedCityName:cityName];
        }
    }
}

#pragma mark -
#pragma mark Rotate

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return toInterfaceOrientation != UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL) shouldAutorotate{
    
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SlideViewController *slideVC = (SlideViewController *)appDelegate.window.rootViewController;
    [slideVC willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:{
        }
        case UIInterfaceOrientationLandscapeRight:{
            filterSegment.frame = CGRectMake(80, 4, SCREEN_HEIGHT - 160, 36);
            closeButton.frame = CGRectMake(SCREEN_HEIGHT - 60, 5, 50, 35);
            cityList.frame = CGRectMake(0, 45, SCREEN_HEIGHT, SCREEN_WIDTH - 45);
            filterView.frame = CGRectMake(0, 45, SCREEN_HEIGHT, SCREEN_WIDTH - 45);
            minPriceField.frame = CGRectMake((SCREEN_HEIGHT - 200)/2, 60, 80, 36);
            maxPriceField.frame = CGRectMake((SCREEN_HEIGHT - 200)/2 + 80 + 40, 60, 80, 36);
            actionBtn.frame = CGRectMake(SCREEN_HEIGHT - 80, 140, 60, 30);
            splitLbl.frame = CGRectMake((SCREEN_HEIGHT - 200)/2 + 80, 60, 40, 36);
            cancelBtn.frame = CGRectMake(SCREEN_HEIGHT - 160, 140, 60, 30);
            break;
        }
        case UIInterfaceOrientationPortrait:{
            filterSegment.frame = CGRectMake(80, 4, SCREEN_WIDTH - 160, 36);
            closeButton.frame = CGRectMake(SCREEN_WIDTH - 60, 5, 50, 35);
            cityList.frame = CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45);
            filterView.frame = CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45);
            minPriceField.frame = CGRectMake((SCREEN_WIDTH - 200)/2, 60, 80, 36);
            maxPriceField.frame = CGRectMake((SCREEN_WIDTH - 200)/2 + 80 + 40, 60, 80, 36);
            splitLbl.frame = CGRectMake((SCREEN_WIDTH - 200)/2 + 80, 60, 40, 36);
            actionBtn.frame = CGRectMake(SCREEN_WIDTH - 80, 140, 60, 30);
            cancelBtn.frame = CGRectMake(SCREEN_WIDTH - 160, 140, 60, 30);
            break;
        }
        default:
            break;
    }
    
}



@end
