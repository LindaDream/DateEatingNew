//
//  YFriendsTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/22.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YFriendsTableViewCell.h"
#import "YContent.h"

@implementation YFriendsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setFriends:(YFriends *)friends{
    if (_friends != friends) {
        _friends = nil;
        _friends = friends;
    }
    self.friendName.text = friends.friendName;
    self.lastChatMessage.text = friends.lastChatMessage;
    
    // 设置头像
    [YContent getContentAvatarWithUserName:friends.friendName SuccessRequest:^(id dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:dict]];
        });
    } failurRequest:^(NSError *error) {
        
    }];
    
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
