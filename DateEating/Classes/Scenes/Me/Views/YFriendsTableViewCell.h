//
//  YFriendsTableViewCell.h
//  DateEating
//
//  Created by lanou3g on 16/7/22.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFriends.h"

@interface YFriendsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;


@property (weak, nonatomic) IBOutlet UILabel *friendName;

@property (weak, nonatomic) IBOutlet UILabel *lastChatMessage;
@property (weak, nonatomic) IBOutlet UILabel *unreadCountLabel;

@property (strong,nonatomic) YFriends *friends;
@end
