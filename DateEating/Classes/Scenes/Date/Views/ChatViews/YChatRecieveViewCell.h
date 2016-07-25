//
//  YChatRecieveViewCell.h
//  DateEating
//
//  Created by user on 16/7/22.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YChatRecieveViewCell : UITableViewCell
@property(strong,nonatomic)UIImageView *headImgView;
@property(strong,nonatomic)UILabel *messageLabel;
@property(strong,nonatomic)UIImageView *backImgView;
@property(strong,nonatomic)UIImage *headImg;
@property(strong,nonatomic)NSString *message;
+ (CGFloat)heightForCellWithMessage:(NSString *)message;
@end
