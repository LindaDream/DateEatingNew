//
//  YChatTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YChatTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YContent.h"

@interface YChatTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *message;


@end

@implementation YChatTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- 重写model的set方法 --
- (void)setModel:(YChatMessageModel *)model {
    if (_model != model) {
        _model = nil;
        _model = model;
        
        if (model.isOurData) {
            [YContent getContentAvatarWithUserName:model.user.nick SuccessRequest:^(id dict) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_userImage sd_setImageWithURL:dict placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
                });
            } failurRequest:^(NSError *error) {
            }];
        } else {
            [_userImage sd_setImageWithURL:[NSURL URLWithString:model.user.userImageUrl] placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
            [_userImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)]];
        }
        _nick.text = model.user.nick;
        if (model.replyUser != nil) {
            _message.text = [NSString stringWithFormat:@"回复%@:%@",model.replyUser.nick,model.content];
        } else {
            _message.text = model.content;
        }
        // 显示时间
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970]*1000;
        CGFloat totalTime = ((NSInteger)nowTime - model.createTime)/1000.0;
        NSInteger day = totalTime/86400;
        NSInteger hour = totalTime/3600;
        NSInteger min = totalTime/60;
        if (day > 0) {
            _time.text = [NSString stringWithFormat:@"%ld天前",day];
        } else if (hour > 0) {
            _time.text = [NSString stringWithFormat:@"%ld小时前",hour];
        } else if (min > 0){
            _time.text = [NSString stringWithFormat:@"%ld分钟前",min];
        } else {
            _time.text = [NSString stringWithFormat:@"小于1分钟"];
        }
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(userImageDidTap:)]) {
        [_delegate userImageDidTap:self.model.userId];
    }
}

+ (CGFloat)getHeightForCellWithActivity:(YChatMessageModel *)activity {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 90, 100000);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};

    // 计算locationLabel的文本高度
    CGRect titleLabel = [activity.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics|NSStringDrawingTruncatesLastVisibleLine attributes:dic context:nil];

    return 50 + titleLabel.size.height;
}

@end
