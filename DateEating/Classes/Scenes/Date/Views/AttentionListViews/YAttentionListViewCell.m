//
//  YAttentionListViewCell.m
//  DateEating
//
//  Created by user on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YAttentionListViewCell.h"

@implementation YAttentionListViewCell
-(void)setModel:(YAttentionListModel *)model{
    if (_model != model) {
        _model = nil;
        _model = model;
    }
    [self.imgView setImageWithURL:[NSURL URLWithString:model.userImageUrl] placeholderImage:[UIImage imageNamed:@"DateLogo.jpg"]];
    [_imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)]];
    self.nameLabel.text = model.nick;
    self.constellationLabel.text = model.constellation;
    if (model.gender == 0) {
        self.backImgView.image = [UIImage imageNamed:@"ic_sex_girl"];
    }else{
        self.backImgView.image = [UIImage imageNamed:@"ic_sex_boy"];
    }
    self.ageLabel.text = [NSString stringWithFormat:@"%ld",model.age];
    self.ageLabel.textColor = [UIColor whiteColor];
}

// 点击图片跳转到个人详情页
- (void)tapAction {
    if (_delegate && [_delegate respondsToSelector:@selector(didTapTheUserImage:)]) {
        [_delegate didTapTheUserImage:self.model.userId];
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
