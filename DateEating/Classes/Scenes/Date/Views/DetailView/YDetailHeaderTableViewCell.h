//
//  YDetailHeaderTableViewCell.h
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDateContentModel.h"

@class YDetailHeaderTableViewCell;
@protocol YDetailHeaderTableViewCellDelegate <NSObject>

- (void)chatBtnDidClicked:(YDetailHeaderTableViewCell *)cell;
- (void)restaurantBtnDidClicked:(YDetailHeaderTableViewCell *)cell;
- (void)reportBtnDidClicked:(YDetailHeaderTableViewCell *)cell;
- (void)userImageDidTap:(NSInteger)userId;

@end

#define YDetailHeaderTableViewCell_Identify @"YDetailHeaderTableViewCell_Identify"
@interface YDetailHeaderTableViewCell : UITableViewCell

@property (strong, nonatomic) YDateContentModel *model;
@property (assign, nonatomic) id<YDetailHeaderTableViewCellDelegate>delegate;
@property (assign, nonatomic) BMKUserLocation *userLocation;

+ (CGFloat)getHeightForCellWithActivity:(YDateContentModel *)activity;

@end
