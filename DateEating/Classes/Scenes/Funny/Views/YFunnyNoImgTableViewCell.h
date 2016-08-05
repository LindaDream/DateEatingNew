//
//  YFunnyNoImgTableViewCell.h
//  DateEating
//
//  Created by user on 16/7/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFunnyModel;
@interface YFunnyNoImgTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;


@property (strong,nonatomic) YFunnyModel *funny;

// 计算有图片cell整体的高度
+ (CGFloat)cellHeight:(YFunnyModel *)funny;
@end
