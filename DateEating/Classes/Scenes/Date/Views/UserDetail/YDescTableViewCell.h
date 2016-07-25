//
//  YDescTableViewCell.h
//  DateEating
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

#define YDescTableViewCell_Indentify @"YDescTableViewCell_Indentify"
@interface YDescTableViewCell : UITableViewCell

- (void)setCellWithName:(NSString *)name desc:(NSString *)desc;

+ (CGFloat)getHeightForCellWithString:(NSString *)string;

@end
