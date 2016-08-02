//
//  YDateOrPartyTableViewCell.h
//  DateEating
//
//  Created by user on 16/7/19.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDateContentModel.h"
@class YDateOrPartyTableViewCell;
@protocol deletePassDateOrParty <NSObject>

- (void)deletePassDateOrParty:(YDateOrPartyTableViewCell *)cell;

@end

@interface YDateOrPartyTableViewCell : UITableViewCell
@property(strong,nonatomic)YDateContentModel *model;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property(weak,nonatomic)id<deletePassDateOrParty> delegate;
@end
