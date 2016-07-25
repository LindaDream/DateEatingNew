//
//  YFunnyTableViewCell.h
//  DateEating
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFunnyModel;

@interface YFunnyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (strong,nonatomic) YFunnyModel *funny;
// 接受图片的数组
@property (strong,nonatomic) NSMutableArray *mArr;

// 计算有图片cell整体的高度
+ (CGFloat)cellHeight:(YFunnyModel *)funny;

@end
