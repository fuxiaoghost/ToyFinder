//
//  DetailViewController.m
//  ToyFinder
//
//  Created by Dawn on 13-5-26.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "DetailViewController.h"
#import "WallButton.h"
#import "StrickoutLabel.h"
#import "DetailPhotoCell.h"
#import "JSON.h"

@interface DetailViewController ()
@property (nonatomic,copy) NSString *detailTitle;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *promotion;
@property (nonatomic,retain) NSArray *photoArray;
@property (nonatomic,copy) NSString *sessionKey;
@property (nonatomic,copy) NSString *numIID;
@property (nonatomic,retain) NSDictionary *detailDict;
@end

@implementation DetailViewController
@synthesize detailTitle;
@synthesize price;
@synthesize promotion;
@synthesize photoArray;
@synthesize sessionKey;
@synthesize numIID;
@synthesize detailDict;

- (void) dealloc{
    self.detailTitle = nil;
    self.price = nil;
    self.promotion = nil;
    self.photoArray = nil;
    self.numIID = nil;
    self.detailDict = nil;
    if (self.sessionKey) {
        [iosClient cancel:[NSString stringWithFormat:@"%@",self.sessionKey]];
        self.sessionKey = nil;
    }

    [super dealloc];
}


- (id) initWithTitle:(NSString *)title price:(NSString *)price_ promotion:(NSString *)promotion_ numIID:(NSString *)numIID_{
    if (self = [super init]) {
        self.detailTitle = title;
        self.price = price_;
        self.promotion = promotion_;
        self.numIID = numIID_;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleBgView.backgroundColor = RGBACOLOR(245,124,0,1);
    [self.view addSubview:titleBgView];
    [titleBgView release];
    
    // 导航栏标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 80, 44)];
    titleLbl.font = [UIFont boldSystemFontOfSize:14.0F];
    titleLbl.textAlignment = UITextAlignmentLeft;
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.numberOfLines = 2;
    titleLbl.lineBreakMode = UILineBreakModeCharacterWrap;
    [self.view addSubview:titleLbl];
    [titleLbl release];
    titleLbl.text = self.detailTitle;
    
    
    UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
    splitView.backgroundColor = RGBACOLOR(217,70,0,1);
    [self.view addSubview:splitView];
    [splitView release];
    
        
    WallButton *closeButton = [WallButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(SCREEN_WIDTH - 60, 5, 50, 35);
    [closeButton setTitle:@"完成" forState:UIControlStateNormal];
    [closeButton setTitleColor:RGBACOLOR(221, 70, 0, 1) forState:UIControlStateNormal];
    [closeButton setTitleColor:RGBACOLOR(255, 255, 255, 1) forState:UIControlStateHighlighted];
    [self.view addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 详情tableview
    detailList = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45) style:UITableViewStylePlain];
    detailList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:detailList];
    [detailList release];
    detailList.dataSource = self;
    detailList.delegate = self;
    
    [self getDetail];
}

- (void) closeButtonClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) getDetail{
    iosClient =[TopIOSClient getIOSClientByAppKey:APP_KEY];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    
    
    [params setObject:@"taobao.taobaoke.items.detail.get" forKey:@"method"];
    [params setObject:@"detail_url,title,nick,type,desc,pic_url,num,location,price,post_fee,express_fee,ems_fee,freight_payer,item_img.url,click_url,shop_click_url,seller_credit_score" forKey:@"fields"];
    [params setObject:NICK forKey:@"nick"];
    [params setObject:@"true" forKey:@"is_mobile"];
    [params setObject:self.numIID forKey:@"num_iids"];
    
    
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
        
        if ([response content]){
            NSDictionary *contentDict = [[response content] JSONValue];
            NSArray *detailArray = [[[contentDict objectForKey:@"taobaoke_items_detail_get_response"] objectForKey:@"taobaoke_item_details"] objectForKey:@"taobaoke_item_detail"];
            self.detailDict = [detailArray objectAtIndex:0];
            self.photoArray = [[[self.detailDict objectForKey:@"item"] objectForKey:@"item_imgs"] objectForKey:@"item_img"];

            [detailList reloadData];
        }else {
            NSLog(@"%@",[(NSError *)[response error] userInfo]);
        }
    }
    
}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == detailList) {
        return 2;
    }else if(tableView == photosList){
        if (self.photoArray) {
            return self.photoArray.count;
        }else {
            return 0;
        }
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (detailList ==  tableView) {
        // 图片
        static NSString *cellIdentifier = @"DetailCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            if(indexPath.row == 0){
                photosList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) style:UITableViewStylePlain];
                photosList.rowHeight = 200;
                photosList.clipsToBounds = NO;
                photosList.backgroundColor = [UIColor clearColor];					//清空背景色
                CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_2);
                photosList.transform = transform;									//旋转TableView
                photosList.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
                photosList.delegate = self;
                photosList.dataSource = self;
                photosList.separatorStyle = UITableViewCellSeparatorStyleNone;
                photosList.sectionFooterHeight= 0.0f;
                photosList.sectionHeaderHeight = 0.0f;
                photosList.showsHorizontalScrollIndicator = NO;
                photosList.showsVerticalScrollIndicator = NO;
                photosList.scrollsToTop = NO;										//禁用点击状态栏滚动到起始位置
                [cell.contentView addSubview:photosList];
                [photosList release];
            }else if(indexPath.row == 1){
                
            }
        }
        [photosList reloadData];
        return cell;
    }else if(photosList == tableView){
        static NSString *cellIdentifier = @"DetailPhotoCell";
        DetailPhotoCell *cell = (DetailPhotoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[DetailPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setPhoto:[[self.photoArray objectAtIndex:indexPath.row] objectForKey:@"url"]];
        return cell;
    }
    return nil;
}

#pragma mark -
#pragma mark UITableViewDelegtae
- (float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(detailList == tableView){
        return 40;
    }
    return 0;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (detailList == tableView) {
        return 200;
    }else if(photosList == tableView){
        return 200;
    }
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == detailList) {
        UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        priceView.backgroundColor = [UIColor whiteColor];
        
        // 价格
        UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 40)];
        priceLbl.backgroundColor = [UIColor clearColor];
        [priceLbl setFont:[UIFont boldSystemFontOfSize:18.0f]];
        priceLbl.textColor = RGBACOLOR(221, 70, 0, 1);
        priceLbl.textAlignment = UITextAlignmentLeft;
        [priceView addSubview:priceLbl];
        [priceLbl release];
        priceLbl.text = self.price;
        
        if (self.promotion) {
            // 促销
            StrickoutLabel *promotionLbl = [[StrickoutLabel alloc] initWithFrame:CGRectMake(80, 0, 70, 40)];
            promotionLbl.backgroundColor = [UIColor clearColor];
            promotionLbl.font = [UIFont systemFontOfSize:14.0f];
            promotionLbl.textColor = [UIColor grayColor];
            promotionLbl.textAlignment = UITextAlignmentLeft;
            [priceView addSubview:promotionLbl];
            [promotionLbl release];
            promotionLbl.text = self.promotion;
        }
        
        
        return [priceView autorelease];
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (detailList == tableView) {

    }else if(photosList == tableView){
        
    }
}



#pragma mark -
#pragma mark Rotate

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return NO;
}

- (BOOL) shouldAutorotate{
    
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
