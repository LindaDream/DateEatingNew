//
//  YDateListTableViewCell.h
//  DateEating
//
//  Created by user on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDateContentModel.h"
#import "YDistanceMangear.h"

#define YDateListTableViewCell_Identify @"YDateListTableViewCell_Identify"

@protocol YDateListTableViewCellDelegate <NSObject>

- (void)clickedUserImage:(YDateContentModel *)model;

@end

@interface YDateListTableViewCell : UITableViewCell

@property (assign, nonatomic) id<YDateListTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *cellIndex;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (strong,nonatomic) YDateContentModel *model;
@property (strong, nonatomic) BMKUserLocation *userLocation;

@end
