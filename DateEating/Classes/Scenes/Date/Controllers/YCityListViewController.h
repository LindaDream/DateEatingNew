//
//  YCityListViewController.h
//  DateEating
//
//  Created by user on 16/7/17.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol passCityName <NSObject>

- (void)passCityName:(NSString *)cityName;

@end

@interface YCityListViewController : UITableViewController
@property(weak,nonatomic)id<passCityName> delegate;
@end
