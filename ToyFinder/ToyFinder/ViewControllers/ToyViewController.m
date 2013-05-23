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

@interface ToyViewController (){
    NSInteger index;
}
@property (nonatomic,copy) NSString *sessionKey;
@property (nonatomic,copy) NSString *cid;
@end

@implementation ToyViewController
@synthesize titleLbl;

- (void) dealloc{
    self.sessionKey = nil;
    self.cid = nil;
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
    titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleLbl.backgroundColor = RGBACOLOR(245,124,0,1);
    titleLbl.font = [UIFont boldSystemFontOfSize:22.0f];
    titleLbl.textAlignment = UITextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLbl];
    [titleLbl release];
    titleLbl.text = @"玩物";
    
    splitView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
    splitView.backgroundColor = RGBACOLOR(217,70,0,1);
    [self.view addSubview:splitView];
    [splitView release];
    
    // 底部状态
    tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30)];
    tipsLbl.textAlignment = UITextAlignmentCenter;
    tipsLbl.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    tipsLbl.font = [UIFont systemFontOfSize:14.0f];
    tipsLbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipsLbl];
    [tipsLbl release];

    NSArray *dataSource = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    
    if (LAYOUT_PORTRAIT || LAYOUT_UPSIDEDOWN) {
        itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 10 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 10 - 44 - 30) dataSource:dataSource itemWidth:260];
    }else{
        itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 10 + 44, SCREEN_HEIGHT, SCREEN_WIDTH - 10 - 44 - 30) dataSource:dataSource itemWidth:340];
    }
    itemView.delegate = self;
    
    [self.view addSubview:itemView];
    [itemView release];
}

- (void) selectCategoryDict:(NSDictionary *)dict{
    index = 1;
    self.cid = [dict objectForKey:@"tag"];
    isMoreRequest = NO;
    [self searchMore];
}


- (void) searchMore{
    TopIOSClient *iosClient =[TopIOSClient getIOSClientByAppKey:APP_KEY];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    
    
    [params setObject:@"taobao.taobaoke.items.get" forKey:@"method"];
    [params setObject:@"num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume" forKey:@"fields"];
    [params setObject:NICK forKey:@"nick"];
    //[params setObject:@"北京" forKey:@"area"];
    //[params setObject:self.cid forKey:@"cid"];
    [params setObject:self.cid forKey:@"keyword"];
    [params setObject:[NSString stringWithFormat:@"%d",index] forKey:@"page_no"];
    [params setObject:[NSString stringWithFormat:@"%d",PAGE_SIZE] forKey:@"page_size"];
     
    
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
            if(isMoreRequest){
                NSDictionary *contentDict = [[response content] JSONValue];
                [contentArray addObjectsFromArray:[[[contentDict objectForKey:@"taobaoke_items_get_response"] objectForKey:@"taobaoke_items"] objectForKey:@"taobaoke_item"]];
                itemView.dataSource = contentArray;
                //[itemView reloadData];
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
#pragma makr ItemViewDelegate

- (void) itemView:(ItemView *)itemView_ didSelectedAtIndex:(NSInteger)index_{
    
}

- (void) itemView:(ItemView *)itemView_ didPageToIndex:(NSInteger)index_{
    if (itemView.dataSource.count - index_ < 3) {
        if (!self.sessionKey) {
            index++;
            isMoreRequest = YES;
            [self searchMore];
        }
    }
    
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
            itemView.frame = CGRectMake(0, 10 + 44, SCREEN_HEIGHT,SCREEN_WIDTH - 10 - 44 - 30);
            titleLbl.frame = CGRectMake(0, 0, SCREEN_HEIGHT, 44);
            splitView.frame = CGRectMake(0, 44, SCREEN_HEIGHT, 1);
            tipsLbl.frame = CGRectMake(0, SCREEN_WIDTH - 30, SCREEN_HEIGHT, 30);
            break;
        }
        case UIInterfaceOrientationPortrait:{
            itemView.itemWidth = 260;
            itemView.frame = CGRectMake(0, 10 + 44, SCREEN_WIDTH, SCREEN_HEIGHT - 10 - 44 - 30);
            titleLbl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
            splitView.frame = CGRectMake(0, 44, SCREEN_WIDTH, 1);
            tipsLbl.frame = CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30);
            break;
        }
        default:
            break;
    }
    
}

@end
