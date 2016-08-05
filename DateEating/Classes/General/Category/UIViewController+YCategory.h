//
//  UIViewController+YCategory.h
//  DateEating
//
//  Created by user on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <EMSDK.h>
@interface UIViewController (YCategory)<BMKLocationServiceDelegate>
@property(assign,nonatomic)CLLocationDegrees userLat;
@property(assign,nonatomic)CLLocationDegrees userLog;

- (UIButton *)addToTopBtn;

// 转变为夜间模式
- (void)changeToNight;
// 转变为白天模式
- (void)changeToDay;
// 按钮动画
- (void)addDateBtnAndPartyBtn;
- (void)removeDateBtnAndPartyBtn;
// label高度自适应
- (CGFloat)textHeightForLabel:(UILabel *)label;
// 计算距离
- (CGFloat)distanceToTarget:(CLLocationDegrees)lat log:(CLLocationDegrees)log;
@end
