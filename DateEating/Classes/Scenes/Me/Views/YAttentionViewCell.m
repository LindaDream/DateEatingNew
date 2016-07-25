//
//  YAttentionViewCell.m
//  DateEating
//
//  Created by user on 16/7/16.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YAttentionViewCell.h"

@implementation YAttentionViewCell
-(void)setModel:(YRestaurantListModel *)model{
    if (_model != model) {
        _model = nil;
        _model = model;
    }
     [self.photoImgView setImageWithURL:[NSURL URLWithString:model.sPhotoUrl] placeholderImage:[UIImage imageNamed:@"DateLogo.jpg"]];
    self.nameLabel.text = model.name;
    self.priceLabel.text = model.avgPrice;
    self.addressLabel.text = model.regionsStr;
    self.typeLabel.text = model.categoriesStr;
    self.countLabel.text = [NSString stringWithFormat:@"%ld人关注",model.caterUserCount];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
