//
//  YDetailHeaderTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YDetailHeaderTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "YDistanceMangear.h"

@interface YDetailHeaderTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *eventDateTime;
@property (weak, nonatomic) IBOutlet UILabel *feeDesc;
@property (weak, nonatomic) IBOutlet UILabel *eventDescription;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *constellation;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *showCount;

@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *credit;

@property (weak, nonatomic) IBOutlet UILabel *eventNumberDesc;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage;

@end

@implementation YDetailHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- 重写model的set方法赋值 --
- (void)setModel:(YDateContentModel *)model {
    if (_model != model) {
        _model = nil;
        _model = model;
        if ([model.ourSeverMark isEqualToString:@"Our"]) {
            _eventDateTime.text = model.dateTime;
            _eventNumberDesc.text = model.eventObject;
            if (model.fee == 0) {
                _feeDesc.text = @"我请客";
            }else {
                _feeDesc.text = @"AA";
            }
        } else {
            NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.eventDateTime/1000];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
            NSString *dateString = [formatter stringFromDate:date];
            _eventDateTime.text = [NSString stringWithFormat:@"%@",dateString];
            _feeDesc.text = model.feeType.desc;
            if (model.multi == 0) {
                if (model.user.gender == 1) {
                    _eventNumberDesc.text = @"邀请一名女性";
                } else {
                    _eventNumberDesc.text = @"邀请一名男性";
                }
            } else {
                _eventNumberDesc.text = @"邀请多人参加";
            }
        }
        
        _eventName.text = model.eventName;
        _eventLocation.text = model.eventLocation;
        CGFloat distance = [[YDistanceMangear sharedYDistanceMangear]getDistanceByUserLocation:self.userLocation Latitude:model.eventLatitude longitude:model.eventLongitude];
        _distance.text = [NSString stringWithFormat:@"%.2lfkm",distance/1000.0];
        _eventDescription.text = model.eventDescription;
        _nick.text = model.user.nick;
        _constellation.text = model.user.constellation;
        _age.text = [NSString stringWithFormat:@"   %ld",model.user.age];
        _showCount.text = [NSString stringWithFormat:@"%ld",model.showCount];
        _credit.text = [NSString stringWithFormat:@"%ld",model.credit];
    
        if (model.user.gender == 0) {
            _genderImage.image = [UIImage imageNamed:@"ic_sex_girl"];
        } else {
            _genderImage.image = [UIImage imageNamed:@"ic_sex_boy"];
        }
        
        [_userImage sd_setImageWithURL:[NSURL URLWithString:model.user.userImageUrl] placeholderImage:[UIImage imageNamed:@"DateLogo.jpg"]];
        [_userImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)]];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentCountChange:) name:@"count" object:nil];
    }
}

// 评论数变化触发的通知中心方法
- (void)commentCountChange:(NSNotification *)notifice {
    NSDictionary *dic = notifice.userInfo;
    self.commentCount.text = dic[@"count"];
}


#pragma mark -- 按钮事件 --
// 点击图片
- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(userImageDidTap:)]) {
        [_delegate userImageDidTap:self.model.userId];
    }
}

// 聊天按钮
- (IBAction)chatBtnAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(chatBtnDidClicked:)]) {
        [_delegate chatBtnDidClicked:self];
    }
}

// 餐厅详情
- (IBAction)acterDetailBtn:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(restaurantBtnDidClicked:)]) {
        [_delegate restaurantBtnDidClicked:self];
    }
}


#pragma mark -- 求cell的高度 --
+ (CGFloat)getHeightForCellWithActivity:(YDateContentModel *)activity {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width -155, 100000);
    NSDictionary *nameDic = @{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]};
    
    // 计算eventName的文本高度
    CGRect nameLabel = [activity.eventName boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics|NSStringDrawingTruncatesLastVisibleLine attributes:nameDic context:nil];
    
    // 计算eventDescription的文本高度
    CGSize size2 = CGSizeMake([UIScreen mainScreen].bounds.size.width -36, 100000);
    NSDictionary *descDic = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]};
    CGRect descLabel = [activity.eventDescription boundingRectWithSize:size2 options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics|NSStringDrawingTruncatesLastVisibleLine attributes:descDic context:nil];
    CGFloat height = 217 + nameLabel.size.height + descLabel.size.height;
    if (height >= 245) {
        return height;
    } else {
        return 245;
    }
}


@end
