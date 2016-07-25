//
//  YImageTableViewCell.h
//  DateEating
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

#define YImageTableViewCell_Indentify @"YImageTableViewCell_Indentify"
@interface YImageTableViewCell : UITableViewCell

@property (strong,nonatomic) NSArray *imageArray;


+ (CGFloat)getHeightForCell:(NSInteger)count;

@end
