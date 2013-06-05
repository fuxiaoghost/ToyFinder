//
//  RootViewController.m
//  ToyFinder
//
//  Created by Dawn on 13-5-18.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "ToyViewController.h"
#import "ItemView.h"
#import "JSON.h"
#import "InfoViewController.h"
#import "AppDelegate.h"
#import "SlideViewController.h"
#import "DetailViewController.h"
#import "DetailNavgationController.h"
#import "ScalableView.h"
#import "CacheManager.h"
#import "HMSegmentedControl.h"
#import "CityViewController.h"

@interface ToyViewController (){
    NSInteger index;
}
@property (nonatomic,copy) NSString *cid;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,assign) NSInteger minPrice;
@property (nonatomic,assign) NSInteger maxPrice;
@end

@implementation ToyViewController
@synthesize cid;
@synthesize url;
@synthesize sort;
@synthesize city;
@synthesize minPrice;
@synthesize maxPrice;

- (void) dealloc{
    if (request) {
        [request cancelRequest];
        request = nil;
    }

    self.cid = nil;
    self.url = nil;
    self.sort = nil;
    self.city = nil;
    [contentArray release];
    [keywordArray release];
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        index = 1;
        contentArray = [[NSMutableArray alloc] initWithCapacity:0];
        keywordArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

#pragma mark -
#pragma mark 界面初始化数据

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 导航栏背景
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 66)];
    }else{
        navBgView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 66)];
    }
    navBgView.backgroundColor = RGBACOLOR(245,124,0,1);
    [self.view addSubview:navBgView];
    
    // 导航栏的分类和筛选按钮
    [self addNavButton];
    
    // 添加搜索框
    [self addSearchBar];
    
    // 排序条
    [self addSortBar];
    
    // 底部的信息展示
    [self addBottomBar];
    
    // 主数据展示区域
    [self addMainView];
    
    // 加载初始化数据
    [self performSelector:@selector(tempSearch) withObject:nil afterDelay:0.3];
}


// 分类和筛选
- (void) addNavButton{
    // left list button
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [listButton setImage:[UIImage noCacheImageNamed:@"list_btn.png"] forState:UIControlStateNormal];
    [listButton setImage:[UIImage noCacheImageNamed:@"list_btn_h.png"] forState:UIControlStateHighlighted];
    listButton.frame = CGRectMake(10, 0, 44, 44);
    [self.view addSubview:listButton];
    [listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterBtn setImage:[UIImage noCacheImageNamed:@"filter_btn.png"] forState:UIControlStateNormal];
    [filterBtn setImage:[UIImage noCacheImageNamed:@"filter_btn_h.png"] forState:UIControlStateHighlighted];
    filterBtn.frame = CGRectMake(SCREEN_WIDTH - 44 - 10, 0, 44, 44);
    [self.view addSubview:filterBtn];
    [filterBtn addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 66, SCREEN_WIDTH, 1)];
    }else{
        splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 66, SCREEN_HEIGHT, 1)];
    }
    
    splitView.backgroundColor = RGBACOLOR(217,70,0,1);
    [self.view addSubview:splitView];
    [splitView release];
}

// 搜索栏
- (void) addSearchBar{
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        keywordBar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 120, 44)];
    }else{
        keywordBar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 0, SCREEN_HEIGHT - 120, 44)];
    }
    
    keywordBar.barStyle = UIBarStyleDefault;
    keywordBar.translucent = YES;
    keywordBar.delegate = self;
    keywordBar.tintColor = RGBACOLOR(245,124,0,1);
    [[keywordBar.subviews objectAtIndex:0]removeFromSuperview];
	
	[self.view addSubview:keywordBar];
    [keywordBar release];
}

// 排序栏
- (void) addSortBar{
    sortControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"人气", @"信用", @"销量", @"价格↑", @"价格↓"]];
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        sortControl.frame = CGRectMake(0, 40, SCREEN_WIDTH, 26);
    }else{
        sortControl.frame = CGRectMake(0, 40, SCREEN_HEIGHT, 26);
    }
    [sortControl setSelectionIndicatorHeight:2.0f];
    [sortControl setBackgroundColor:RGBACOLOR(245,124,0,1)];//RGBACOLOR(245,124,0,1)];//
    [sortControl setTextColor:[UIColor whiteColor]];
    [sortControl setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [sortControl setSelectionIndicatorColor:RGBACOLOR(217,70,0,1)];
    [sortControl setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
    [sortControl setSegmentEdgeInset:UIEdgeInsetsMake(0, 6, 0, 6)];
    [sortControl setTag:2];
    [sortControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [navBgView addSubview:sortControl];
    [sortControl release];

}

- (void) addBottomBar{
    // 底部状态
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40)];
    }else{
        tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH - 40, SCREEN_HEIGHT, 40)];
    }
    tipsLbl.textAlignment = UITextAlignmentCenter;
    tipsLbl.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    tipsLbl.font = [UIFont systemFontOfSize:14.0f];
    tipsLbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipsLbl];
    [tipsLbl release];
    
    // infobutton
    infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [self.view addSubview:infoButton];
    [infoButton addTarget:self action:@selector(infoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        infoButton.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 40, 60, 40);
        infoButton.hidden = NO;
    }else{
        infoButton.frame = CGRectMake(SCREEN_HEIGHT - 60, SCREEN_WIDTH - 40, 60, 40);
        infoButton.hidden = YES;
    }
}

- (void) addMainView{
    NSArray *dataSource = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 10 + 44 + 22, SCREEN_WIDTH, SCREEN_HEIGHT - 10 - 44 - 40 - 22) dataSource:dataSource itemWidth:ITEM_WIDTH];
    }else{
        itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 10 + 44 + 22, SCREEN_HEIGHT, SCREEN_WIDTH - 10 - 44 - 40 - 22) dataSource:dataSource itemWidth:ITEM_HEIGHT];
    }
    itemView.delegate = self;
    [self.view addSubview:itemView];
    [itemView release];
}


#pragma mark -
#pragma mark Private Methods

- (void) tempSearch{
    index = 1;
    self.sort = @"default";
    self.cid = @"连衣裙";
    [self searchMore];
    self.url = @"";
}


- (void) searchMore{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:@"taobao.taobaoke.items.get" forKey:@"method"];
    [params setObject:@"num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume" forKey:@"fields"];
    [params setObject:NICK forKey:@"nick"];
    if (self.city) {
        [params setObject:self.city forKey:@"area"];
    }
    //[params setObject:self.cid forKey:@"cid"];
    if (self.minPrice) {
        [params setObject:[NSString stringWithFormat:@"%d",self.minPrice] forKey:@"start_price"];
    }
    if (self.maxPrice) {
        [params setObject:[NSString stringWithFormat:@"%d",self.maxPrice] forKey:@"end_price"];
    }
    [params setObject:self.sort forKey:@"sort"];
    [params setObject:self.cid forKey:@"keyword"];
    [params setObject:@"true" forKey:@"is_mobile"];
    [params setObject:[NSString stringWithFormat:@"%d",index] forKey:@"page_no"];
    [params setObject:[NSString stringWithFormat:@"%d",TOY_PAGE_SIZE] forKey:@"page_size"];
    
    if (request) {
        [request cancelRequest];
        request = nil;
    }
    request = [TBHttRequest requestWithParams:params];
    request.delegate = self;
    [request startGetRequest];
    
}

- (void) searchKeyword:(NSString *)keyword{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setObject:@"taobao.kfc.keyword.search" forKey:@"method"];
    [params setObject:NICK forKey:@"nick"];
    [params setObject:keyword forKey:@"content"];
    
    if (keywordRequest) {
        [keywordRequest cancelRequest];
        keywordRequest = nil;
    }
    keywordRequest = [TBHttRequest requestWithParams:params];
    keywordRequest.delegate = self;
    [keywordRequest startGetRequest];
}


#pragma mark -
#pragma mark Actions

- (void) infoButtonClick:(id)sender{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SlideViewController *slideVC = (SlideViewController *)appDelegate.window.rootViewController;
    
    InfoViewController *infoVC = [[InfoViewController alloc] initWithUrl:self.url title:self.cid];
    [slideVC presentModalViewController:infoVC animated:YES];
    [infoVC release];
}

- (void) selectKeyword:(NSString *)keyword infoUrl:(NSString *)url_{
    index = 1;
    self.sort = @"default";
    self.cid = keyword;
    [self searchMore];
    self.url = url_;
}

- (void) listButtonClick:(id)sender{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SlideViewController *slideVC = (SlideViewController *)appDelegate.window.rootViewController;
    if (slideVC.isBackShow) {
        [slideVC slideUp];
    }else{
        [slideVC slideDown];
    }
}

- (void) filterBtnClick:(id)sender{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SlideViewController *slideVC = (SlideViewController *)appDelegate.window.rootViewController;
    
    CityViewController *cityVC = [[CityViewController alloc] init];
    cityVC.delegate = self;
    cityVC.city = self.city;
    cityVC.minPrice = self.minPrice;
    cityVC.maxPrice = self.maxPrice;
    [slideVC presentModalViewController:cityVC animated:YES];
    [cityVC release];
}


#pragma mark -
#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        keywordBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    }else{
        keywordBar.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 44);
    }
    
    [UIView commitAnimations];
    [searchBar setShowsCancelButton:YES animated:NO];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        keywordBar.frame = CGRectMake(60, 0, SCREEN_WIDTH - 120, 44);
    }else{
        keywordBar.frame = CGRectMake(60, 0, SCREEN_HEIGHT - 120, 44);
    }
   
    [UIView commitAnimations];
    [searchBar setShowsCancelButton:NO animated:NO];
    return YES;
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    if (STRINGHASVALUE(searchBar.text)) {
        self.cid = searchBar.text;
        [self searchMore];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (keywordArray) {
        return keywordArray.count;
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
    cell.textLabel.text = @"";
    return cell;
}

#pragma mark -
#pragma mark TBHtteRequestDelegate
- (void) requestFailed:(TBHttRequest *)request_{
    if (request_ == request) {
        request = nil;
    }else if(request_ == keywordRequest){
        keywordRequest = nil;
    }
}

- (void) requestFinished:(TBHttRequest *)request_ withDict:(NSDictionary *)dict{
    if (request_ == request) {
        [contentArray removeAllObjects];
        [contentArray addObjectsFromArray:[[[dict objectForKey:@"taobaoke_items_get_response"] objectForKey:@"taobaoke_items"] objectForKey:@"taobaoke_item"]];
        itemView.dataSource = contentArray;
        [itemView reloadData];
        tipsLbl.text = [NSString stringWithFormat:@"%d/%d",1,contentArray.count];
        request = nil;
    }else if(request_ == keywordRequest){
        NSLog(@"%@",dict);
    }
    
}


- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSInteger index_ = segmentedControl.selectedIndex;
    //"sort_priceup_btn.png",@"sort_pricedown_btn.png",@"sort_credite_btn.png",@"sort_sale_btn.png",,@"sort_popular_btn.png",@"sort_main_btn.png"
    switch (index_) {
        case 3:{
            // 价格升序
            self.sort = @"price_asc";
            break;
        }
        case 4:{
            self.sort = @"price_desc";
            // 价格降序
            break;
        }
        case 2:{
            self.sort = @"credit_desc";
            // 信用降序
            break;
        }
        case 1:{
            // 销量降序
            self.sort = @"commissionNum_desc";
            break;
        }
        case 0:{
            // 人气
            self.sort = @"default";
            break;
        }
        default:
            break;
    }
    
    [self searchMore];
    
}

#pragma mark -
#pragma mark CityViewControllerDelegate
- (void) cityViewController:(CityViewController *)cityViewController didSelectedCityName:(NSString *)cityName{
    self.city = cityName;
    [self searchMore];
}

- (void) cityViewController:(CityViewController *)cityViewController didSetMinPrice:(NSInteger)minPrice_ maxPrice:(NSInteger)maxPrice_{
    self.minPrice = minPrice_;
    self.maxPrice = maxPrice_;
    [self searchMore];
}

#pragma mark -
#pragma makr ItemViewDelegate

- (void) itemView:(ItemView *)itemView_ didSelectedAtIndex:(NSInteger)index_{
    NSDictionary *dict = [itemView.dataSource objectAtIndex:index_];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        if ([dict objectForKey:@"title"]) {
            NSString *titleHtml = [dict objectForKey:@"title"];
            NSString *regEx = @"<([^>]*)>";
            NSRange range;
            while ((range = [titleHtml rangeOfString:regEx options:NSRegularExpressionSearch]).location != NSNotFound){
                titleHtml = [titleHtml stringByReplacingCharactersInRange:range withString:@""];
            }
            
            NSString *price = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"price"]];
            NSString *promotion = nil;
            if ([dict objectForKey:@"promotion_price"]) {
                promotion = [NSString stringWithFormat:@"¥%@",[dict objectForKey:@"promotion_price"]];
            }else{
                promotion = nil;
            }
            NSString *numIID = [dict objectForKey:@"num_iid"];
            
            DetailViewController *detailVC = [[DetailViewController alloc] initWithTitle:titleHtml price:price promotion:promotion numIID:numIID];
            
            DetailNavgationController *navController = [[DetailNavgationController alloc] initWithRootViewController:detailVC];
            [detailVC release];
            
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            SlideViewController *slideVC = (SlideViewController *)appDelegate.window.rootViewController;
            
            [slideVC presentModalViewController:navController animated:YES];
            [navController release];
        }
    }
}

- (void) itemView:(ItemView *)itemView_ didPageToIndex:(NSInteger)index_{
//    if (itemView.dataSource.count - index_ < 3) {
//        if (!self.sessionKey) {
//            index++;
//            isMoreRequest = YES;
//            [self searchMore];
//        }
//    }
    
    tipsLbl.text = [NSString stringWithFormat:@"%d/%d",index_+1,contentArray.count];
}


#pragma mark -
#pragma mark Rotate

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return YES;
}

- (BOOL) shouldAutorotate{
    
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:{
        }
        case UIInterfaceOrientationLandscapeRight:{
            itemView.itemWidth = ITEM_HEIGHT;
            itemView.frame = CGRectMake(0, 10 + 44 + 22 , SCREEN_HEIGHT,SCREEN_WIDTH - 10 - 44 - 40 - 22);
            navBgView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 66);
            splitView.frame = CGRectMake(0, 66, SCREEN_HEIGHT, 1);
            tipsLbl.frame = CGRectMake(0, SCREEN_WIDTH - 40, SCREEN_HEIGHT,40);
            infoButton.frame = CGRectMake(SCREEN_HEIGHT - 60, SCREEN_WIDTH - 40, 60, 40);
            filterBtn.frame = CGRectMake(SCREEN_HEIGHT - 44 - 10, 0, 44, 44);
            keywordBar.frame = CGRectMake(60, 0, SCREEN_HEIGHT - 120, 44);
            sortControl.frame = CGRectMake(0, 40, SCREEN_HEIGHT, 26);
            break;
        }
        case UIInterfaceOrientationPortrait:{
            itemView.itemWidth = ITEM_WIDTH;
            itemView.frame = CGRectMake(0, 10 + 44 + 22, SCREEN_WIDTH, SCREEN_HEIGHT - 10 - 44 - 40 - 22);
            navBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 66);
            splitView.frame = CGRectMake(0, 66, SCREEN_WIDTH, 1);
            tipsLbl.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
            infoButton.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 40, 60, 40);
            filterBtn.frame = CGRectMake(SCREEN_WIDTH - 44 - 10, 0, 44, 44);
            keywordBar.frame = CGRectMake(60, 0, SCREEN_WIDTH - 120, 44);
            sortControl.frame = CGRectMake(0, 40, SCREEN_WIDTH, 26);
            break;
        }
        default:
            break;
    }
    
}

@end
