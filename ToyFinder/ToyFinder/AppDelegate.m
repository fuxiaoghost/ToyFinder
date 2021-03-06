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
#import "UMeng/MobClick.h"

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
    toyVC.view.backgroundColor = [UIColor colorWithWhite:217.0f/255.0f alpha:1];
    
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

    /************UMeng数据统计分析*********************/
    [MobClick setCrashReportEnabled:NO];
    [MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH channelId:CHANNEL_ID];
    
    return YES;
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
