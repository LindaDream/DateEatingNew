//
//  YContentTableViewCell.h
//  DateEating
//
//  Created by user on 16/7/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YContent.h"

@protocol YContentTableViewCellDelegate <NSObject>

- (void)showReport;

@end

@interface YContentTableViewCell : UITableViewCell

@property (strong,nonatomic) YContent *content;

@property (weak, nonatomic) IBOutlet UILabel *fromToLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *contentAvatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak,nonatomic) id<YContentTableViewCellDelegate> delegate;

+ (CGFloat)cellHeight:(YContent *)content;

@end
