//
//  MealDetailsViewController.h
//  ShiYi
//
//  Created by lanou3g on 15/11/1.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YMealDetailsModel;

@interface MealDetailsViewController : UIViewController

@property (nonatomic, strong)NSString *ID;
@property (nonatomic, strong)YMealDetailsModel *model;

@end
