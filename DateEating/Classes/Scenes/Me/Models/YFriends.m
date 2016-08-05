//
//  YFriends.m
//  DateEating
//
//  Created by user on 16/7/22.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YFriends.h"

@implementation YFriends

// 获取本地所有好友的列表
+ (NSArray *)getFriend{
    
    NSArray *conversationList = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];;
    NSMutableArray *friendsArr = [NSMutableArray array];
    NSLog(@"%@",conversationList);
    for (EMConversation *conversation in conversationList) {
        if (friendsArr.count != 0) {
            BOOL flag = NO;
            for (YFriends *f in friendsArr) {
                if (f.friendName == conversation.conversationId) {
                    flag = YES;
                    break;
                }
            }
            if (flag == NO) {
                YFriends *friend = [YFriends new];
                friend.friendName = conversation.conversationId;
                NSString *lastChatMessage = [self getEveryFriendLastChatMessageWithConversation:conversation];
                if (lastChatMessage != nil) {
                    friend.lastChatMessage = lastChatMessage;
                }
                [friendsArr addObject:friend];
            }
        }else{
            YFriends *friend = [YFriends new];
            friend.friendName = conversation.conversationId;
            NSString *lastChatMessage = [self getEveryFriendLastChatMessageWithConversation:conversation];
            if (lastChatMessage != nil) {
                friend.lastChatMessage = lastChatMessage;
            }
            [friendsArr addObject:friend];
        }
        
    }

    return friendsArr;
}

// 将好友列表包装成对象，并且获取每个人的最后一条聊天数据
+ (NSString *)getEveryFriendLastChatMessageWithConversation:(EMConversation *)conversation{

    // 获取聊天消息
    NSMutableArray *msgArr = [NSMutableArray new];
    msgArr = [conversation loadMoreMessagesContain:nil before:-1 limit:20 from:nil direction:(EMMessageSearchDirectionUp)].mutableCopy;
//    NSIndexPath *msgIndex = [NSIndexPath indexPathForRow:msgArr.count - 1 inSection:0];
    EMMessage *message = [msgArr lastObject];
    EMTextMessageBody *messageBody = (EMTextMessageBody *)message.body;
    
    if (message.body.type == 1) {
        return messageBody.text;
    }else if (message.body.type == 2){
        return @"[图片]";
    }
    return nil;
}

- (NSString *)description{

    return [NSString stringWithFormat:@"%@",self.friendName];
    
}


@end
