//
//  AppDelegate.h
//  DateEating
//
//  Created by user on 16/7/11.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(strong,nonatomic)BMKMapManager *mapManager;
@end

