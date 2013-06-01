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
@end

@implementation ToyViewController
@synthesize cid;
@synthesize url;
@synthesize sort;

- (void) dealloc{
    if (request) {
        [request cancelRequest];
        request = nil;
    }

    self.cid = nil;
    self.url = nil;
    self.sort = nil;
    [contentArray release];
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        index = 1;
        contentArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

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
    
    // 排序栏
    HMSegmentedControl *sortControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"人气", @"信用", @"销量", @"价格↑", @"价格↓"]];
    
    sortControl.frame = CGRectMake(0, 40, SCREEN_WIDTH, 26);
    [sortControl setSelectionIndicatorHeight:2.0f];
    [sortControl setBackgroundColor:RGBACOLOR(245,124,0,1)];//RGBACOLOR(245,124,0,1)];//
    [sortControl setTextColor:[UIColor whiteColor]];
    [sortControl setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [sortControl setSelectionIndicatorColor:RGBACOLOR(217,70,0,1)];
    [sortControl setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];
    [sortControl setSegmentEdgeInset:UIEdgeInsetsMake(0, 6, 0, 6)];
    [sortControl setTag:2];
    [sortControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [navBgView addSubview:sortControl];
    [sortControl release];
    
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

    NSArray *dataSource = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 10 + 44 + 22, SCREEN_WIDTH, SCREEN_HEIGHT - 10 - 44 - 40 - 22) dataSource:dataSource itemWidth:260];
    }else{
        itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 10 + 44 + 22, SCREEN_HEIGHT, SCREEN_WIDTH - 10 - 44 - 40 - 22) dataSource:dataSource itemWidth:340];
    }
    itemView.delegate = self;
    [self.view addSubview:itemView];
    [itemView release];

}

- (void) infoButtonClick:(id)sender{
    InfoViewController *infoVC = [[InfoViewController alloc] initWithUrl:self.url title:self.cid];
    [self presentModalViewController:infoVC animated:YES];
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
    CityViewController *cityVC = [[CityViewController alloc] init];
    [self presentModalViewController:cityVC animated:YES];
    [cityVC release];
}


- (void) searchMore{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [params setObject:@"taobao.taobaoke.items.get" forKey:@"method"];
    [params setObject:@"num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume" forKey:@"fields"];
    [params setObject:NICK forKey:@"nick"];
    //[params setObject:@"北京" forKey:@"area"];
    //[params setObject:self.cid forKey:@"cid"];
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

#pragma mark -
#pragma mark TBHtteRequestDelegate
- (void) requestFailed:(TBHttRequest *)request_{
    request = nil;
}

- (void) requestFinished:(TBHttRequest *)request_ withDict:(NSDictionary *)dict{
    [contentArray removeAllObjects];
    [contentArray addObjectsFromArray:[[[dict objectForKey:@"taobaoke_items_get_response"] objectForKey:@"taobaoke_items"] objectForKey:@"taobaoke_item"]];
    itemView.dataSource = contentArray;
    [itemView reloadData];
    tipsLbl.text = [NSString stringWithFormat:@"%d/%d",1,contentArray.count];
    request = nil;
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
            
            [self presentModalViewController:navController animated:YES];
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
            itemView.itemWidth = 340;
            itemView.frame = CGRectMake(0, 10 + 44 + 22 , SCREEN_HEIGHT,SCREEN_WIDTH - 10 - 44 - 40 - 22);
            navBgView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 66);
            splitView.frame = CGRectMake(0, 66, SCREEN_HEIGHT, 1);
            tipsLbl.frame = CGRectMake(0, SCREEN_WIDTH - 40, SCREEN_HEIGHT,40);
            infoButton.frame = CGRectMake(SCREEN_HEIGHT - 60, SCREEN_WIDTH - 40, 60, 40);
            infoButton.hidden = YES;
            filterBtn.frame = CGRectMake(SCREEN_HEIGHT - 44 - 10, 0, 44, 44);
            break;
        }
        case UIInterfaceOrientationPortrait:{
            itemView.itemWidth = 260;
            itemView.frame = CGRectMake(0, 10 + 44 + 22, SCREEN_WIDTH, SCREEN_HEIGHT - 10 - 44 - 40 - 22);
            navBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 66);
            splitView.frame = CGRectMake(0, 66, SCREEN_WIDTH, 1);
            tipsLbl.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
            infoButton.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 40, 60, 40);
            infoButton.hidden = NO;
            filterBtn.frame = CGRectMake(SCREEN_WIDTH - 44 - 10, 0, 44, 44);
            break;
        }
        default:
            break;
    }
    
}

@end
