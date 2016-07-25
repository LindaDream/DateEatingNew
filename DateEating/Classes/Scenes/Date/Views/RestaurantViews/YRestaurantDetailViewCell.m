//
//  YRestaurantDetailViewCell.m
//  DateEating
//
//  Created by user on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YRestaurantDetailViewCell.h"

@implementation YRestaurantDetailViewCell
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setModel:(YRestaurantListModel *)model{
    if (_model != model) {
        _model = nil;
        _model = model;
    }
    [self.photoImgView sd_setImageWithURL:[NSURL URLWithString:model.sPhotoUrl] placeholderImage:[UIImage imageNamed:@"DateLogo.jpg"]];
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"人均￥%@元",model.avgPrice];
    self.addressLabel.text = model.regionsStr;
    self.typeLabel.text = model.categoriesStr;
    self.countLabel.text = [NSString stringWithFormat:@"%ld人关注",model.caterUserCount];
    [self.eatBtn addTarget:self action:@selector(eatBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)eatBtnAction:(UIButton *)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(passCurrentCell:)]) {
        [_delegate passCurrentCell:self];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
