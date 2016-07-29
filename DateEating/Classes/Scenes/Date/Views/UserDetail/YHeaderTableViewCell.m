//
//  YHeaderTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YHeaderTableViewCell.h"
#import "YDistanceMangear.h"

@interface YHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *onLineTime;
@property (weak, nonatomic) IBOutlet UILabel *nick;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UIImageView *gender;
@property (weak, nonatomic) IBOutlet UILabel *constellation;
@property (weak, nonatomic) IBOutlet UILabel *height;
@property (weak, nonatomic) IBOutlet UILabel *personInfo;
@end

@implementation YHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(YUserDetailModel *)model {
    _model = model;
    
    // 设置动画
    _userImage.layer.cornerRadius = 40;
    _userImage.layer.masksToBounds = YES;
    _userImage.layer.borderWidth = 2.0f;
    _userImage.layer.borderColor = (__bridge CGColorRef _Nullable)YRGBColor(100, 89, 64);
    
    [UIView beginAnimations:@"center" context:nil];
    [UIView setAnimationRepeatAutoreverses:YES];
    // 设置重复次数
    [UIView setAnimationRepeatCount:1000];
    [UIView setAnimationDuration:1.5];
    _userImage.transform = CGAffineTransformScale(_userImage.transform, 1.06, 1.06);
    [UIView commitAnimations];
    
    NSArray *array = [model.pics componentsSeparatedByString:@","];
    [_userImage sd_setImageWithURL:[NSURL URLWithString:array.firstObject] placeholderImage:[UIImage imageNamed:@"DateLogo.jpg"]];
    CGFloat distance = [[YDistanceMangear sharedYDistanceMangear]getDistanceByUserLocation:nil Latitude:model.lat longitude:model.lng];
    _distance.text = [NSString stringWithFormat:@"%.2lfkm",distance/1000.0];
    _nick.text = model.nick;
    if (model.gender == 0) {
        _gender.image = [UIImage imageNamed:@"ic_sex_girl"];
    } else {
        _gender.image = [UIImage imageNamed:@"ic_sex_boy"];
    }
    _age.textAlignment = NSTextAlignmentRight;
    _age.text = [NSString stringWithFormat:@"     %ld",model.age];
    _constellation.text = model.constellation;
    _height.text = [NSString stringWithFormat:@"%ldcm",model.height];
    _personInfo.text = model.personalInfo;
    if (!model.lastOnlineTime) {
        _onLineTime.text = [NSString stringWithFormat:@""];
    } else {
        // 显示时间
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970]*1000;
        CGFloat totalTime = ((NSInteger)nowTime - model.lastOnlineTime.integerValue)/1000.0;
        NSInteger day = totalTime/86400;
        NSInteger hour = totalTime/3600;
        NSInteger min = totalTime/60;
        if (day > 0) {
            _onLineTime.text = [NSString stringWithFormat:@"%ld天前",day];
        } else if (hour > 0) {
            _onLineTime.text = [NSString stringWithFormat:@"%ld小时前",hour];
        } else if (min > 0){
            _onLineTime.text = [NSString stringWithFormat:@"%ld分钟前",min];
        } else {
            _onLineTime.text = [NSString stringWithFormat:@"小于1分钟"];
        }
    }    
}

@end
