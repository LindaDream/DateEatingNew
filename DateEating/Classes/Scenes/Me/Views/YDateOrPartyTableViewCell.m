//
//  YDateOrPartyTableViewCell.m
//  DateEating
//
//  Created by user on 16/7/19.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YDateOrPartyTableViewCell.h"

@implementation YDateOrPartyTableViewCell
-(void)setModel:(YDateContentModel *)model{
    if (_model != model) {
        _model = nil;
        _model = model;
    }
    self.themeLabel.text = model.eventName;
    self.addressLabel.text = model.eventLocation;
    self.dateTimeLabel.text = model.dateTime;
    if (model.fee == 0) {
        self.feeTypeLabel.text = @"我请客";
    }else{
        self.feeTypeLabel.text = @"AA";
    }
    self.descriptionLabel.text = model.eventDescription;
    if (model.img == nil) {
        self.headImgView.image = [UIImage imageNamed:@"head_img"];
    }else{
        self.headImgView.image = model.img;
    }
}

- (IBAction)deleteAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(deletePassDateOrParty:)]) {
        [_delegate deletePassDateOrParty:self];
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
