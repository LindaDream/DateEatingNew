//
//  ViewMacro.h
//  ShiYi
//
//  Created by lanou3g on 15/10/27.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#ifndef ViewMacro_h
#define ViewMacro_h


// 屏幕宽度
#define kUIScreenWidth [[UIScreen mainScreen] bounds].size.width
// 屏幕高度
#define kUIScreenHeight [[UIScreen mainScreen] bounds].size.height
// 去除导航栏和tabbar后剩余的屏幕
#define kMainFrame CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height - 20)

// 去除导航栏后剩余的屏幕
#define kMainFrameNoTabBar CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.navigationController.navigationBar.frame.size.height)

// 轮播图页码选中时显示颜色
#define kMainColor [UIColor colorWithRed:255/255.0 green:110/255.0 blue:0/255.0 alpha:1]

#define kMyWidth [[UIScreen mainScreen] bounds].size.width / 375

#define kMyHight [[UIScreen mainScreen] bounds].size.height / 667

#endif /* ViewMacro_h */
