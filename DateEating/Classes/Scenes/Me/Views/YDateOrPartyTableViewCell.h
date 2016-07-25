//
//  YDateOrPartyTableViewCell.h
//  DateEating
//
//  Created by user on 16/7/19.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDateContentModel.h"
@interface YDateOrPartyTableViewCell : UITableViewCell
@property(strong,nonatomic)YDateContentModel *model;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@end
