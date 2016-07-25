//
//  YAttentionListViewCell.h
//  DateEating
//
//  Created by user on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAttentionListModel.h"

@protocol YAttentionListViewCellDelegate <NSObject>

- (void)didTapTheUserImage:(NSInteger)userId;

@end

@interface YAttentionListViewCell : UITableViewCell
@property (strong,nonatomic) id<YAttentionListViewCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *constellationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property(strong,nonatomic)YAttentionListModel *model;
@end
