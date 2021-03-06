//
//  YDetailViewController.h
//  DateEating
//
//  Created by user on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDateContentModel.h"

typedef void(^PassNewCount)(NSInteger);
@interface YDetailViewController : UIViewController

@property (strong,nonatomic) YDateContentModel *model;
@property (strong,nonatomic) BMKUserLocation *userLocation;
@property (copy, nonatomic) PassNewCount passNewCount;
@property (assign, nonatomic) BOOL isListData;

@end
