//
//  YRestaurantDetailViewCell.h
//  DateEating
//
//  Created by user on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRestaurantListModel.h"
@class YRestaurantDetailViewCell;
@protocol passCurrentCell <NSObject>

- (void)passCurrentCell:(YRestaurantDetailViewCell *)cell;

@end

@interface YRestaurantDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eatBtnImg;
@property (weak, nonatomic) IBOutlet UILabel *eatBtnLabel;
@property (weak, nonatomic) IBOutlet UIButton *eatBtn;
@property(strong,nonatomic)YRestaurantListModel *model;
@property(weak,nonatomic)id<passCurrentCell> delegate;
@end
