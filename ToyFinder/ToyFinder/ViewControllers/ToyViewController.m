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

@interface ToyViewController (){
    NSInteger index;
}
@property (nonatomic,copy) NSString *sessionKey;
@property (nonatomic,copy) NSString *cid;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,copy) NSString *requestUrl;
@end

@implementation ToyViewController
@synthesize titleLbl;
@synthesize sessionKey;
@synthesize cid;
@synthesize url;
@synthesize sort;
@synthesize requestUrl;

- (void) dealloc{
    if (self.sessionKey) {
        [iosClient cancel:[NSString stringWithFormat:@"%@",self.sessionKey]];
        self.sessionKey = nil;
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
    
    // 导航栏标题
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    }else{
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 44)];
    }
    titleLbl.backgroundColor = RGBACOLOR(245,124,0,1);
    titleLbl.font = [UIFont boldSystemFontOfSize:22.0f];
    titleLbl.textAlignment = UITextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLbl];
    [titleLbl release];
    titleLbl.text = @"玩物";
    
    // left list button
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [listButton setImage:[UIImage noCacheImageNamed:@"list_btn.png"] forState:UIControlStateNormal];
    [listButton setImage:[UIImage noCacheImageNamed:@"list_btn_h.png"] forState:UIControlStateHighlighted];
    listButton.frame = CGRectMake(10, 0, 44, 44);
    [self.view addSubview:listButton];
    [listButton addTarget:self action:@selector(listButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];  
    }else{
        splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_HEIGHT, 1)];
    }
    
    splitView.backgroundColor = RGBACOLOR(217,70,0,1);
    [self.view addSubview:splitView];
    [splitView release];
    
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
        itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 10 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 10 - 44 - 40) dataSource:dataSource itemWidth:260];
    }else{
        itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 10 + 44, SCREEN_HEIGHT, SCREEN_WIDTH - 10 - 44 - 40) dataSource:dataSource itemWidth:340];
    }
    itemView.delegate = self;
    [self.view addSubview:itemView];
    [itemView release];
    
    // 排序按钮
    sortView = [[ScalableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH - 20, 40) images:[NSArray arrayWithObjects:@"sort_priceup_btn.png",@"sort_pricedown_btn.png",@"sort_credite_btn.png",@"sort_sale_btn.png",@"sort_popular_btn.png",@"sort_main_btn.png", nil] highlightedImages:[NSArray arrayWithObjects:@"sort_priceup_btn_h.png",@"sort_pricedown_btn_h.png",@"sort_credite_btn_h.png",@"sort_sale_btn_h.png",@"sort_popular_btn_h.png",@"sort_main_btn_h.png", nil] direction:FromLeftToRight firstSpace:50];
    sortView.delegate = self;
    [self.view addSubview:sortView];
    [sortView release];
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
    isMoreRequest = NO;
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


- (void) searchMore{
    iosClient  =[TopIOSClient getIOSClientByAppKey:APP_KEY];
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
    
    NSMutableString *keystr = [NSMutableString string];
    for (NSString *mkey in [params allKeys]) {
        [keystr appendFormat:@"%@:%@;",mkey,[params objectForKey:mkey]];
    }
    self.requestUrl = keystr;
    
    CacheManager *cacheManager = [CacheManager manager];
    NSData *data = [cacheManager cacheForKey:self.requestUrl];
    if (data) {
        
    }
    
    if (self.sessionKey) {
        [iosClient cancel:[NSString stringWithFormat:@"%@",self.sessionKey]];
        self.sessionKey = nil;
    }
    
    self.sessionKey = [iosClient api:@"GET" params:params target:self cb:@selector(showApiResponse:) userId:NICK needMainThreadCallBack:true];
    
}

-(void)showApiResponse:(id)data{
    self.sessionKey = nil;
    if ([data isKindOfClass:[TopApiResponse class]]){
        TopApiResponse *response = (TopApiResponse *)data;
        NSLog(@"%@",response.reqParams);
        if ([response content]){
            if(isMoreRequest){
                NSDictionary *contentDict = [[response content] JSONValue];
                [contentArray addObjectsFromArray:[[[contentDict objectForKey:@"taobaoke_items_get_response"] objectForKey:@"taobaoke_items"] objectForKey:@"taobaoke_item"]];
                itemView.dataSource = contentArray;
            }else{
                [contentArray removeAllObjects];
                NSDictionary *contentDict = [[response content] JSONValue];
                [contentArray addObjectsFromArray:[[[contentDict objectForKey:@"taobaoke_items_get_response"] objectForKey:@"taobaoke_items"] objectForKey:@"taobaoke_item"]];
                itemView.dataSource = contentArray;
                [itemView reloadData];
                tipsLbl.text = [NSString stringWithFormat:@"%d/%d",1,contentArray.count];
            }
        }
        else {
            NSLog(@"%@",[(NSError *)[response error] userInfo]);
        }
    }
    
}

#pragma mark -
#pragma mark ScalableViewDelegate
- (void) scalableView:(ScalableView *)ScalableView didSelectedAtIndex:(NSInteger)index_{
    NSLog(@"%d",index_);
    //"sort_priceup_btn.png",@"sort_pricedown_btn.png",@"sort_credite_btn.png",@"sort_sale_btn.png",,@"sort_popular_btn.png",@"sort_main_btn.png"
    switch (index_) {
        case 0:{
            // 价格升序
            self.sort = @"price_asc";
            break;
        }
        case 1:{
            self.sort = @"price_desc";
            // 价格降序
            break;
        }
        case 2:{
            self.sort = @"credit_desc";
            // 信用降序
            break;
        }
        case 3:{
            // 销量降序
            self.sort = @"commissionNum_desc";
            break;
        }
        case 4:{
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
            itemView.frame = CGRectMake(0, 10 + 44, SCREEN_HEIGHT,SCREEN_WIDTH - 10 - 44 - 40);
            titleLbl.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 44);
            splitView.frame = CGRectMake(0, 44, SCREEN_HEIGHT, 1);
            tipsLbl.frame = CGRectMake(0, SCREEN_WIDTH - 40, SCREEN_HEIGHT,40);
            infoButton.frame = CGRectMake(SCREEN_HEIGHT - 60, SCREEN_WIDTH - 40, 60, 40);
            infoButton.hidden = YES;
            sortView.frame = CGRectMake(0, SCREEN_WIDTH - 40, SCREEN_HEIGHT - 20, 40);
            break;
        }
        case UIInterfaceOrientationPortrait:{
            itemView.itemWidth = 260;
            itemView.frame = CGRectMake(0, 10 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 10 - 44 - 40);
            titleLbl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
            splitView.frame = CGRectMake(0, 44, SCREEN_WIDTH, 1);
            tipsLbl.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
            infoButton.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 40, 60, 40);
            infoButton.hidden = NO;
            sortView.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH - 20, 40);
            break;
        }
        default:
            break;
    }
    
}

@end
