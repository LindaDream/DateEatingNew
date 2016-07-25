//
//  YHeaderTableViewCell.h
//  DateEating
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUserDetailModel.h"


#define YHeaderTableViewCell_Indentify @"YHeaderTableViewCell_Indentify"
@interface YHeaderTableViewCell : UITableViewCell

@property (strong, nonatomic) YUserDetailModel *model;

@end
