//
//  YThemeTableViewCell.m
//  DateEating
//
//  Created by user on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YThemeTableViewCell.h"

@implementation YThemeTableViewCell

- (void)awakeFromNib {
    self.themeTF.delegate = self;
    // Initialization code
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
