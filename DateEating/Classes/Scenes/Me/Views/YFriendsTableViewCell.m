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
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"hxUserName" equalTo:friends.friendName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count != 0) {
            [YContent getContentAvatarWithHxuserName:friends.friendName SuccessRequest:^(id dict) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (dict != nil) {
                        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:dict]placeholderImage:[UIImage imageNamed:@"head_img"]];
                    }
                });
            } failurRequest:^(NSError *error) {
                NSLog(@"--------%ld",error.code);
            }];
        }else if(error != nil){
            NSLog(@"%ld",error.code);
        }else if(objects.count == 0){
            AVQuery *query1 = [AVQuery queryWithClassName:@"ChatFriendsList"];
            [query1 whereKey:@"friendName" equalTo:friends.friendName];
            [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (objects.count != 0) {
                    AVObject *obj = objects.firstObject;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[obj objectForKey:@"avatarUrl"]]placeholderImage:[UIImage imageNamed:@"head_img"]];
                    });
                }else if(error != nil){
                    NSLog(@"======%ld",error.code);
                }else if (objects.count == 0){
                    NSLog(@"没有头像");
                }
            }];
        }
    }];
    
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
