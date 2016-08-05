//
//  YMealTableViewCell.m
//  DateEating
//
//  Created by user on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YMealOrPlayTableViewCell.h"

@implementation YMealOrPlayTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.categoryIconImageView.layer.masksToBounds = YES;
    self.categoryIconImageView.layer.cornerRadius = 5;
    
    self.backImageView.layer.masksToBounds = YES;
    self.backImageView.layer.cornerRadius = 10;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 10;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setMeal:(YMealModel *)meal{

    _meal = meal;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:meal.picUrl] placeholderImage:[UIImage imageNamed:@"zhanwei.jpg"]];
    self.titleLabel.text = _meal.title;
    self.addressOrDurationLabel.text = _meal.address;
    self.priceStrLabel.text = _meal.priceStr;
    
}

- (void)setPlay:(YPlayModel *)play{

    _play = play;
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:_play.picUrl]placeholderImage:[UIImage imageNamed:@"zhanwei.jpg"]];
    self.titleLabel.text = _play.title;
    self.addressOrDurationLabel.text = _play.duration;
    self.priceStrLabel.text = _play.neededCredits;
    [self.categoryIconImageView sd_setImageWithURL:[NSURL URLWithString:_play.categoryIconUrl]placeholderImage:[UIImage imageNamed:@"zhanwei.jpg"]];
}



@end
