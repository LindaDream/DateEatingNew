//
//  YMealTableViewCell.h
//  DateEating
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMealModel.h"
#import "YPlayModel.h"

@interface YMealOrPlayTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressOrDurationLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceStrLabel;

@property (weak, nonatomic) IBOutlet UIImageView *categoryIconImageView;

@property (weak, nonatomic) IBOutlet UIView *backView;


@property (strong,nonatomic) YMealModel *meal;

@property (strong,nonatomic) YPlayModel *play;

@end
