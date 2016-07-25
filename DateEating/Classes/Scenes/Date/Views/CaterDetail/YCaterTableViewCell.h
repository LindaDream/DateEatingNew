//
//  YCaterTableViewCell.h
//  DateEating
//
//  Created by lanou3g on 16/7/16.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

#define YCaterTableViewCell_Indentify @"YCaterTableViewCell_Indentify"
@interface YCaterTableViewCell : UITableViewCell



- (void)setCellWithImage:(NSString *)imageName title:(NSString *)title;

+ (CGFloat)getHeightForCellWithString:(NSString *)string;

@end
