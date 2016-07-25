//
//  YObjectTableViewCell.m
//  DateEating
//
//  Created by user on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YObjectTableViewCell.h"

@implementation YObjectTableViewCell
-(void)setIsSelected:(BOOL)isSelected{
    if (_isSelected != isSelected) {
        _isSelected = nil;
        _isSelected = isSelected;
    }
}
- (void)awakeFromNib {
    // Initialization code
}
// 女生
- (IBAction)girlAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.isSelected) {
        [btn setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:(UIControlStateNormal)];
        self.isSelected = NO;
        if (_objDelegate && [_objDelegate respondsToSelector:@selector(passObject:cell:)]) {
            [_objDelegate passObject:@"邀请一位女生" cell:self];
        }
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"notSelected"] forState:(UIControlStateNormal)];
        self.isSelected = YES;
    }
}
// 男生
- (IBAction)boyAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.isSelected) {
        [btn setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:(UIControlStateNormal)];
        self.isSelected = NO;
        if (_objDelegate && [_objDelegate respondsToSelector:@selector(passObject:cell:)]) {
            [_objDelegate passObject:@"邀请一位男生" cell:self];
        }
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"notSelected"] forState:(UIControlStateNormal)];
        self.isSelected = YES;
    }

}
// 不限
- (IBAction)anyAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.isSelected) {
        [btn setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:(UIControlStateNormal)];
        self.isSelected = NO;
        if (_objDelegate && [_objDelegate respondsToSelector:@selector(passObject:cell:)]) {
            [_objDelegate passObject:@"不限男女" cell:self];
        }
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"notSelected"] forState:(UIControlStateNormal)];
        self.isSelected = YES;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
