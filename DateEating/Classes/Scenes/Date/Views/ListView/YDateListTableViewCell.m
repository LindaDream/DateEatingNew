//
//  YDateListTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YDateListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface YDateListTableViewCell ()

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
@property (weak, nonatomic) IBOutlet UILabel *credit;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage;


@end

@implementation YDateListTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(YDateContentModel *)model {
    if (_model != model) {
        _model = nil;
        _model = model;
        if ([model.ourSeverMark isEqual:@"Our"]) {
            _eventDateTime.text = model.dateTime;
            if (model.fee == 0) {
                _feeDesc.text = @"我请客";
            }else {
                _feeDesc.text = @"AA";
            }
             _credit.text = [NSString stringWithFormat:@"%d",20];
        } else {
            _credit.text = [NSString stringWithFormat:@"%ld",model.credit];
            NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.eventDateTime/1000];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
            NSString *dateString = [formatter stringFromDate:date];
            _eventDateTime.text = [NSString stringWithFormat:@"%@",dateString];
            _feeDesc.text = model.feeType.desc;
        }
        
        _eventName.text = model.eventName;
        _eventLocation.text = model.eventLocation;
        _eventDescription.text = model.eventDescription;
        
        CGFloat distance = [[YDistanceMangear sharedYDistanceMangear]getDistanceByUserLocation:self.userLocation Latitude:model.eventLatitude longitude:model.eventLongitude];
        _distance.text = [NSString stringWithFormat:@"%.2lfkm",distance/1000.0];
        _nick.text = model.user.nick;
        _constellation.text = model.user.constellation;
        _age.text = [NSString stringWithFormat:@"     %ld ",model.user.age];
        _showCount.text = [NSString stringWithFormat:@"%ld",model.showCount];
        _commentCount.text = [NSString stringWithFormat:@"%ld",model.commentCount];
        
        [_userImage sd_setImageWithURL:[NSURL URLWithString:model.user.userImageUrl] placeholderImage:[UIImage imageNamed:@"DateLogo.jpg"]];
        
        if (model.user.gender == 0) {
            _genderImage.image = [UIImage imageNamed:@"ic_sex_girl"];
        } else {
            _genderImage.image = [UIImage imageNamed:@"ic_sex_boy"];
        }
        
        [_userImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)]];
        _userImage.userInteractionEnabled = YES;
    }
}

- (void)tapAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(clickedUserImage:)]) {
        [_delegate clickedUserImage:self.model];
    }
}
@end
