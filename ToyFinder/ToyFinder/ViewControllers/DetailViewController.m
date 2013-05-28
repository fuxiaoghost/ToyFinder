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
#import "FullImageView.h"
#import "AppDelegate.h"
#import "DetailViewCell.h"
#import "FullInfoViewController.h"

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
    detailList = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45 - 40) style:UITableViewStylePlain];
    detailList.separatorStyle = UITableViewCellSeparatorStyleNone;  
    [self.view addSubview:detailList];
    [detailList release];
    detailList.dataSource = self;
    detailList.delegate = self;
    
    // 购买
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    buyButton.frame = CGRectMake(100, SCREEN_HEIGHT - 35, 120, 30);
    buyButton.backgroundColor = RGBACOLOR(245,124,0,1);
    buyButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyButton setTitle:@"去购买" forState:UIControlStateNormal];
    [self.view addSubview:buyButton];
    [buyButton addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getDetail];
}

- (void) buyButtonClick:(id)sender{
    FullInfoViewController *fullInfoVC = [[FullInfoViewController alloc] init];
    fullInfoVC.titleInfo = @"订单填写";
    fullInfoVC.navUrl = [self.detailDict objectForKey:@"click_url"];
    [self.navigationController pushViewController:fullInfoVC animated:YES];
    [fullInfoVC release];
}

- (void) closeButtonClick:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) getDetail{
    iosClient =[TopIOSClient getIOSClientByAppKey:APP_KEY];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    
    
    [params setObject:@"taobao.taobaoke.items.detail.get" forKey:@"method"];
    [params setObject:@"detail_url,title,nick,type,desc,pic_url,num,location,price,post_fee,express_fee,ems_fee,freight_payer,item_img.url,click_url,shop_click_url,seller_credit_score,skus" forKey:@"fields"];
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
            
            NSLog(@"%@",self.detailDict);
        }else {
            NSLog(@"%@",[(NSError *)[response error] userInfo]);
        }
    }
    
}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == detailList) {
        return 3;
    }
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == detailList) {
        if (section == 0) {
            return 1;
        }else if(section == 1){
            return 2;
        }else {
            return 2;
        }
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
        if (indexPath.row == 0 && indexPath.section == 0) {
            static NSString *cellIdentifier = @"DetailPhoto";
            UITableViewCell *cell =  (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                photosList = [[UITableView alloc] initWithFrame:CGRectMake(6, 0, SCREEN_WIDTH-12, 154) style:UITableViewStylePlain];
                photosList.rowHeight = 200;
                photosList.clipsToBounds = NO;
                photosList.pagingEnabled = YES;
                photosList.backgroundColor = [UIColor clearColor];					//清空背景色
                CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_2);
                photosList.transform = transform;									//旋转TableView
                photosList.frame = CGRectMake(6, 0, SCREEN_WIDTH-12, 154);
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
            }
            [photosList reloadData];
            return cell;
        }else{
            // 图片
            static NSString *cellIdentifier = @"DetailCell";
            DetailViewCell *cell = (DetailViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[DetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (indexPath.section == 1 && indexPath.row == 0) {
                // 快递费用
                [cell setCellType:-1];
                cell.arrowView.hidden = YES;
                cell.titleLbl.frame = CGRectMake(20, 4,SCREEN_WIDTH - 20 - 20, 20);
                cell.titleLbl.font = [UIFont systemFontOfSize:14.0f];
                cell.titleLbl.textColor = [UIColor colorWithWhite:0.2 alpha:1];
                cell.titleLbl.backgroundColor = [UIColor clearColor];
                
                // 宝贝所在地
                cell.detailLbl.frame = CGRectMake(20, 24, SCREEN_WIDTH - 20 - 20, 20);
                cell.detailLbl.font = [UIFont systemFontOfSize:12.0f];
                cell.detailLbl.textColor = [UIColor colorWithWhite:0.6 alpha:1];
                cell.detailLbl.backgroundColor = [UIColor clearColor];
                
                cell.splitView.hidden = NO;
                
                // 刷新快递费用
                if ([[[self.detailDict objectForKey:@"item"] objectForKey:@"freight_payer"] isEqualToString:@"seller"]) {
                    cell.titleLbl.text = @"卖家承担运费";
                }else if([[[self.detailDict objectForKey:@"item"] objectForKey:@"freight_payer"] isEqualToString:@"buyer"]){
                    NSMutableString *expressFee = [NSMutableString string];
                    float express = [[[self.detailDict objectForKey:@"item"] objectForKey:@"express_fee"] floatValue];
                    float ems = [[[self.detailDict objectForKey:@"item"] objectForKey:@"ems_fee"] floatValue];
                    float post = [[[self.detailDict objectForKey:@"item"] objectForKey:@"post_fee"] floatValue];
                    if (express > 0) {
                        [expressFee appendFormat:@"快递 ¥%.2f; ",express];
                    }
                    if (ems > 0) {
                        [expressFee appendFormat:@"EMS ¥%.2f; ",ems];
                    }
                    if (post > 0) {
                        [expressFee appendFormat:@"平邮 ¥%.2f; ",post];
                    }
                    cell.titleLbl.text = expressFee;
                }else{
                    cell.titleLbl.text = @"";
                }
                
                // 宝贝所在地
                if([[self.detailDict objectForKey:@"item"] objectForKey:@"location"]){
                    NSString *city = [[[self.detailDict objectForKey:@"item"] objectForKey:@"location"] objectForKey:@"city"];
                    NSString *state = [[[self.detailDict objectForKey:@"item"] objectForKey:@"location"] objectForKey:@"state"];
                    if ([city isEqualToString:state]) {
                        cell.detailLbl.text = [NSString stringWithFormat:@"%@",city];
                    }else{
                        cell.detailLbl.text = [NSString stringWithFormat:@"%@ %@",state,city];
                    }
                    
                }else{
                    cell.detailLbl.text = @"";
                }
                
                cell.creditView.image = nil;
            }else if(indexPath.section == 1 && indexPath.row == 1){
                [cell setCellType:1];
                cell.arrowView.hidden = NO;
                cell.splitView.hidden = YES;
                cell.titleLbl.frame = CGRectMake(20, 0,SCREEN_WIDTH - 20 - 20, 44);
                cell.titleLbl.font = [UIFont systemFontOfSize:14.0f];
                cell.titleLbl.textColor = [UIColor colorWithWhite:0.2 alpha:1];
                cell.titleLbl.backgroundColor = [UIColor clearColor];
                
                cell.titleLbl.text = @"宝贝详情";
                cell.detailLbl.text = @"";
                cell.creditView.image = nil;
            }else if(indexPath.section == 2 && indexPath.row == 0){
                // 快递费用
                [cell setCellType:-1];
                cell.arrowView.hidden = YES;
                cell.titleLbl.frame = CGRectMake(20, 4,SCREEN_WIDTH - 20 - 20, 20);
                cell.titleLbl.font = [UIFont systemFontOfSize:14.0f];
                cell.titleLbl.textColor = [UIColor colorWithWhite:0.2 alpha:1];
                cell.titleLbl.backgroundColor = [UIColor clearColor];
                
                // 宝贝所在地
                cell.detailLbl.text = @"";
                cell.splitView.hidden = NO;

                NSString *nick = [[self.detailDict objectForKey:@"item"] objectForKey:@"nick"];
                cell.titleLbl.text = [NSString stringWithFormat:@"卖家昵称：%@",nick];
                
                cell.creditView.frame = CGRectMake(20, 24, SCREEN_WIDTH - 20 - 20, 12);
                cell.creditView.image = [UIImage noCacheImageNamed:[NSString stringWithFormat:@"seller_%@.png",[self.detailDict objectForKey:@"seller_credit_score"]]];
                
            }else if(indexPath.section == 2 && indexPath.row == 1){
                [cell setCellType:1];
                cell.arrowView.hidden = NO;
                cell.splitView.hidden = YES;
                cell.titleLbl.frame = CGRectMake(20, 0,SCREEN_WIDTH - 20 - 20, 44);
                cell.titleLbl.font = [UIFont systemFontOfSize:14.0f];
                cell.titleLbl.textColor = [UIColor colorWithWhite:0.2 alpha:1];
                cell.titleLbl.backgroundColor = [UIColor clearColor];
                
                cell.titleLbl.text = @"卖家店铺";
                cell.detailLbl.text = @"";
                cell.creditView.image = nil;
            }
            
            return cell;
        }
        
        
                
               
        /*

         1星               1
         2星               2
         3星               3
         4星               4
         5星               5
         1钻               6
         2钻               7
         3钻               8
         4钻               9
         5钻               10
         1蓝冠             11
         2蓝冠             12
         3蓝冠             13
         4蓝冠             14
         5蓝冠             15
         1皇冠             16
         2皇冠             17
         3皇冠             18
         4皇冠             19
         5皇冠             20
         */
        
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
        if (section == 0) {
            return 40;
        }else {
            return 10;
        }
    }
    return 0;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (detailList == tableView) {
        if (indexPath.section == 0) {
            return 154;
        }else{
            return 44;
        }
    }else if(photosList == tableView){
        return 154;
    }
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == detailList) {
        if (section == 0) {
            UIView *priceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            priceView.backgroundColor = [UIColor whiteColor];
            
            // 价格
            UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 40)];
            priceLbl.backgroundColor = [UIColor clearColor];
            [priceLbl setFont:[UIFont boldSystemFontOfSize:18.0f]];
            priceLbl.textColor = RGBACOLOR(221, 70, 0, 1);
            priceLbl.textAlignment = UITextAlignmentLeft;
            [priceView addSubview:priceLbl];
            [priceLbl release];
            priceLbl.text = self.price;
            
            if (self.promotion) {
                // 促销
                StrickoutLabel *promotionLbl = [[StrickoutLabel alloc] initWithFrame:CGRectMake(90, 0, 80, 40)];
                promotionLbl.backgroundColor = [UIColor clearColor];
                promotionLbl.font = [UIFont systemFontOfSize:14.0f];
                promotionLbl.textColor = [UIColor grayColor];
                promotionLbl.textAlignment = UITextAlignmentLeft;
                [priceView addSubview:promotionLbl];
                [promotionLbl release];
                promotionLbl.text = self.promotion;
            }
            return [priceView autorelease];
        }else{
            UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
            spaceView.backgroundColor = [UIColor clearColor];
            return [spaceView autorelease];
            
            return nil;
        }
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (detailList == tableView) {
        if (indexPath.section == 1 && indexPath.row == 1) {
            FullInfoViewController *fullInfoVC = [[FullInfoViewController alloc] init];
            fullInfoVC.titleInfo = @"宝贝详情";
            fullInfoVC.fullInfo = [[self.detailDict objectForKey:@"item"] objectForKey:@"desc"];
            [self.navigationController pushViewController:fullInfoVC animated:YES];
            [fullInfoVC release];
        }else if(indexPath.section == 2 && indexPath.row == 1){
            FullInfoViewController *shopVC = [[FullInfoViewController alloc] init];
            shopVC.titleInfo = @"卖家店铺";
            shopVC.navUrl = [self.detailDict objectForKey:@"shop_click_url"];
            [self.navigationController pushViewController:shopVC animated:YES];
            [shopVC release];
        }
    }else if(photosList == tableView){
        NSMutableArray *fullImageArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dict in self.photoArray) {
            [fullImageArray addObject:[dict objectForKey:@"url"]];
        }
        FullImageView *detailImage = [[FullImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Images:fullImageArray AtIndex:indexPath.row];
        
        detailImage.delegate = self;
        detailImage.alpha = 0;
        
        
        AppDelegate  *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.window addSubview:detailImage];
        [detailImage release];
        
        [UIView animateWithDuration:0.3 animations:^{
            detailImage.alpha = 1;
        }];
    }
}


#pragma mark -
#pragma mark FullImageViewDelegate
- (void) fullImageView:(FullImageView *)fullImageView didClosedAtIndex:(NSInteger)index{
//    [photosList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


@end
