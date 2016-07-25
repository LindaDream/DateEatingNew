//
//  YContentTableViewCell.h
//  DateEating
//
//  Created by lanou3g on 16/7/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YContent.h"

@interface YContentTableViewCell : UITableViewCell

@property (strong,nonatomic) YContent *content;

@property (weak, nonatomic) IBOutlet UILabel *fromToLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *contentAvatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;



+ (CGFloat)cellHeight:(YContent *)content;

@end
