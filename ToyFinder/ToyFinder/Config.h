//
//  Config.h
//  HotelFinder
//
//  Created by Wang Shuguang on 13-5-13.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#ifndef HotelFinder_Config_h
#define HotelFinder_Config_h

#define APP_KEY         @"21501339"
#define APP_SECRET      @"df925fc22f81305f7fe458b0c4d17486"
#define APP_CALLBACKURL @"appcallback://"


#define SCREEN_4_INCH           (SCREEN_HEIGHT == 568)                          // 4寸Retina
#define SCREEN_WIDTH			([[UIScreen mainScreen] bounds].size.width)     // Screen width
#define SCREEN_HEIGHT			([[UIScreen mainScreen] bounds].size.height)    // Screen height
#define NAVBAR_HEIGHT           44
#define MAINCONTENTHEIGHT       (SCREEN_HEIGHT - NAVBAR_HEIGHT - 20)            // Content height
#define COEFFICIENT_Y   (SCREEN_4_INCH ? 1.183 : 1)                             // 视图控件y轴偏移量系数
#define LAYOUT_PORTRAIT         self.interfaceOrientation == UIDeviceOrientationPortrait
#define LAYOUT_UPSIDEDOWN       self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown
#define LAYOUT_LANDSCAPELEFT    self.interfaceOrientation == UIDeviceOrientationLandscapeLeft
#define LAYOUT_LANDSCAPERIGHT   self.interfaceOrientation == UIDeviceOrientationLandscapeRight
#define LAYOUT_FACEUP           self.interfaceOrientation == UIDeviceOrientationFaceUp
#define LAYOUT_FACEDOWN         self.interfaceOrientation == UIDeviceOrientationFaceDown

// 判断系统版本是否大于x.x
#define IOSVersion_3_2			([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2)
#define IOSVersion_4			([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
#define IOSVersion_5			([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IOSVersion_6			([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)

//常用函数
// 获取资源文件路径
#define RESOURCEFILE(x,y)       [[NSBundle mainBundle] pathForResource:x ofType:y]

// COLOR
#define RGBACOLOR(r,g,b,a)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
// 判断字符串是否为空
#define STRINGHASVALUE(str)		(str && [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)

#endif
