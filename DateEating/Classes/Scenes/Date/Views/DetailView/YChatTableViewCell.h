//
//  YChatTableViewCell.h
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YChatMessageModel.h"

#define YChatTableViewCell_Indentify @"YChatTableViewCell_Indentify"

@protocol YChatTableViewCellDelegate <NSObject>

- (void)userImageDidTap:(NSInteger)userId;

@end

@interface YChatTableViewCell : UITableViewCell

@property (strong,nonatomic) YChatMessageModel *model;
@property (assign,nonatomic) id<YChatTableViewCellDelegate>delegate;

+ (CGFloat)getHeightForCellWithActivity:(YChatMessageModel *)activity;


@end
