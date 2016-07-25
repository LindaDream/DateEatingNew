//
//  YChatMessageModel.h
//  DateEating
//
//  Created by lanou3g on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YActionUserModel.h"

@interface YChatMessageModel : NSObject

@property (assign, nonatomic) NSInteger action;         // 未知
@property (assign, nonatomic) NSInteger actionTime;     // 消息发送时间
@property (strong, nonatomic) NSString *content;        // 消息内容
@property (assign, nonatomic) NSInteger createTime;     // 消息创建时间
@property (assign, nonatomic) NSInteger eventId;        // 活动的id
@property (assign, nonatomic) NSInteger ID;             // 一条消息的id
@property (strong, nonatomic) YActionUserModel *replyUser;// 回复某人的信息
@property (assign, nonatomic) NSInteger replyUserId;    // 回复对象的id
@property (strong, nonatomic) NSString *time;           // 消息的时间
@property (strong, nonatomic) YActionUserModel *user;   // 发消息的人
@property (assign, nonatomic) NSInteger userId;         // 发送消息人的id
@property (assign, nonatomic) BOOL isOurData;
+ (NSMutableArray *)getDateContentListWithDic:(NSDictionary *)dict;

@end
