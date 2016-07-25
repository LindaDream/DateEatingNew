//
//  YRestaurantViewController.h
//  DateEating
//
//  Created by user on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRestaurantDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *restaurantTableView;
@property(assign,nonatomic)NSInteger count;
@property(strong,nonatomic)NSString *businessId;
@property(strong,nonatomic)NSString *addressStr;
@property(strong,nonatomic)NSString *nameStr;
@property(assign,nonatomic)BOOL isDateView;
@property(assign,nonatomic)BOOL fromDetailVC;
@end
