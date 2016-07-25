//
//  YCityTableViewController.h
//  DateEating
//
//  Created by lanou3g on 16/7/19.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCityListModel.h"

@protocol YCityTableViewControllerDelegate <NSObject>

- (void)didSelectCity:(YCityListModel *)model;

@end

@interface YCityTableViewController : UITableViewController

@property (strong, nonatomic) id<YCityTableViewControllerDelegate>delegate;

@end
