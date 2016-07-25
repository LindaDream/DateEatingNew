//
//  YMapViewController.h
//  DateEating
//
//  Created by user on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "YRestaurantDetailModel.h"
@interface YMapViewController : UIViewController
@property(strong,nonatomic)YRestaurantDetailModel *model;
@end
