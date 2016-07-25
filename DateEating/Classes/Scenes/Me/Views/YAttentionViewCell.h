//
//  YAttentionViewCell.h
//  DateEating
//
//  Created by user on 16/7/16.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRestaurantListModel.h"
@interface YAttentionViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property(strong,nonatomic)YRestaurantListModel *model;
@end
