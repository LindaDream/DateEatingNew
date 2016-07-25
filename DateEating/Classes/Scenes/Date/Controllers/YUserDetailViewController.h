//
//  YUserDetailViewController.h
//  DateEating
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDateContentModel.h"

@interface YUserDetailViewController : UIViewController

@property (strong, nonatomic) YDateContentModel * model;
@property (assign, nonatomic) NSInteger userId;

@end
