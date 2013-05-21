//
//  AppDelegate.m
//  ToyFinder
//
//  Created by Wang Shuguang on 13-5-16.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "AppDelegate.h"
#import "SlideViewController.h"
#import "ToyViewController.h"
#import "CategoryViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    SlideViewController *slideVC = [[SlideViewController alloc] init];
    
    ToyViewController *toyVC = [[ToyViewController alloc] init];
    toyVC.view.backgroundColor = [UIColor whiteColor];
    
    CategoryViewController *categoryVC = [[CategoryViewController alloc] init];
    categoryVC.view.backgroundColor = [UIColor whiteColor];
    
    slideVC.backViewController = categoryVC;
    slideVC.topViewController = toyVC;
    [categoryVC release];
    [toyVC release];
    
    self.window.rootViewController = slideVC;
    [slideVC release];
    
    
    // 注册淘宝SDK
    [TopIOSClient registerIOSClient:APP_KEY
                          appSecret:APP_SECRET
                        callbackUrl:APP_CALLBACKURL
               needAutoRefreshToken:YES];

    //[self performSelector:@selector(startRequest) withObject:nil afterDelay:0.6];
    
    return YES;
}

- (void) startRequest{
    //50011949
    //{"itemcats_get_response":{"item_cats":{"item_cat":[{"cid":50016161,"is_parent":false,"name":"酒店客栈","parent_cid":50011949},{"cid":50019784,"is_parent":true,"name":"酒店客栈套餐","parent_cid":50011949}]}}}
    
    TopIOSClient *iosClient =[TopIOSClient getIOSClientByAppKey:APP_KEY];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    /*
     [params setObject:@"taobao.itemprops.get" forKey:@"method"];
     [params setObject:@"pid,name,must,multi,prop_values" forKey:@"fields"];
     [params setObject:@"50016161" forKey:@"cid"];
     //[params setObject:@"6503015:52847" forKey:@"child_path"];
     //[params setObject:@"4618707:63595280" forKey:@"child_path"];
     */
    
    
    
    [params setObject:@"taobao.itemcats.get" forKey:@"method"];
    [params setObject:@"cid,parent_cid,name,is_parent" forKey:@"fields"];
    [params setObject:@"50010099" forKey:@"parent_cid"];
    
    
    /*
    [params setObject:@"taobao.taobaoke.items.get" forKey:@"method"];
    [params setObject:@"num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume" forKey:@"fields"];
    [params setObject:[@"c半缘君c" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"nick"];
    [params setObject:@"北京" forKey:@"area"];
    [params setObject:@"50020856" forKey:@"cid"];
    [params setObject:@"1" forKey:@"page_no"];
    [params setObject:@"40" forKey:@"page_size"];
    */
    
    
    //[params setObject:@"taobao.user.buyer.get" forKey:@"method"];
    //[params setObject:@"user_id,nick,sex,buyer_credit,avatar,has_shop,vip_info" forKey:@"fields"];
    
    
    [iosClient api:@"GET" params:params target:self cb:@selector(showApiResponse:) userId:@"c半缘君c" needMainThreadCallBack:true];
}



/*
 Dict(4): {"cid":50020808,"is_parent":true,"name":"家居饰品","parent_cid":0}
    Dict(4): {"cid":50020856,"is_parent":true,"name":"创意饰品","parent_cid":50020808}
 
 Dict(4): {"cid":50020857,"is_parent":true,"name":"特色手工艺","parent_cid":0}
 
 
 Dict(4): {"cid":21,"is_parent":true,"name":"居家日用/婚庆/创意礼品","parent_cid":0}
    Dict(4): {"cid":50010099,"is_parent":true,"name":"伞/雨具/防雨/防潮","parent_cid":21}
       {"cid":210211,"is_parent":false,"name":"伞","parent_cid":50010099}
    Dict(4): {"cid":50012512,"is_parent":true,"name":"保暖贴/怀炉/保暖用品","parent_cid":21}
    Dict(4): {"cid":50016434,"is_parent":true,"name":"创意礼品","parent_cid":21}
 
 Dict(4): {"cid":50008163,"is_parent":true,"name":"床上用品/布艺软饰","parent_cid":0}
    Dict(4): {"cid":290209,"is_parent":true,"name":"十字绣/刺绣工具配件","parent_cid":50008163}
    Dict(4): {"cid":50024922,"is_parent":true,"name":"十字绣/刺绣","parent_cid":50008163}
    Dict(4): {"cid":50012051,"is_parent":false,"name":"家居拖鞋/凉拖/棉拖/居家鞋","parent_cid":50008163}
    Dict(4): {"cid":213002,"is_parent":false,"name":"靠垫/抱枕","parent_cid":50008163}
 
 
 Dict(4): {"cid":25,"is_parent":true,"name":"玩具/模型/动漫/早教/益智","parent_cid":0}
    {"cid":50011975,"is_parent":false,"name":"毛绒布艺类玩具","parent_cid":25}
    {"cid":50012770,"is_parent":false,"name":"娃娃\/配件","parent_cid":25}
 
 Dict(4): {"cid":28,"is_parent":true,"name":"ZIPPO/瑞士军刀/眼镜","parent_cid":0}
    {"cid":2908,"is_parent":false,"name":"ZIPPO\/芝宝","parent_cid":28}
    {"cid":290601,"is_parent":false,"name":"瑞士军刀","parent_cid":28}
    {"cid":50010368,"is_parent":false,"name":"太阳眼镜","parent_cid":28}
    {"cid":2909,"is_parent":true,"name":"烟具","parent_cid":28}
 */


-(void)showApiResponse:(id)data
{
    if ([data isKindOfClass:[TopApiResponse class]]){
        TopApiResponse *response = (TopApiResponse *)data;
        
        if ([response content]){
            NSLog(@"%@",[response content]);
        }
        else {
            NSLog(@"%@",[(NSError *)[response error] userInfo]);
        }
        
        NSDictionary *dictionary = (NSDictionary *)[response reqParams];
        
        for (id key in dictionary) {
            
            NSLog(@"key: %@, value: %@", key, [dictionary objectForKey:key]);
            
        }
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
