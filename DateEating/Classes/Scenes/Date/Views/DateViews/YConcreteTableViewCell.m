//
//  YConcreteTableViewCell.m
//  DateEating
//
//  Created by user on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YConcreteTableViewCell.h"

@implementation YConcreteTableViewCell
-(void)setIsSelect:(BOOL)isSelect{
    if (_isSelect != isSelect) {
        _isSelect = nil;
        _isSelect = isSelect;
    }
}
- (void)awakeFromNib {
    // Initialization code
}
// 我请客
- (IBAction)mypayAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.isSelect) {
        [btn setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:(UIControlStateNormal)];
        self.isSelect = NO;
        if (_delegate && [_delegate respondsToSelector:@selector(passConcreteValue:cell:)]) {
            [_delegate passConcreteValue:@"我请客" cell:self];
        }
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"notSelected"] forState:(UIControlStateNormal)];
        self.isSelect = YES;
    }
}
// AA
- (IBAction)AAAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (self.isSelect) {
        [btn setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:(UIControlStateNormal)];
        self.isSelect = NO;
        if (_delegate && [_delegate respondsToSelector:@selector(passConcreteValue:cell:)]) {
            [_delegate passConcreteValue:@"AA" cell:self];
        }
    }else{
        [btn setBackgroundImage:[UIImage imageNamed:@"notSelected"] forState:(UIControlStateNormal)];
        self.isSelect = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
