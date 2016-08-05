//
//  YFriends.h
//  DateEating
//
//  Created by user on 16/7/22.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFriends : NSObject

@property (strong,nonatomic) NSString *friendName;
@property (strong,nonatomic) NSString *lastChatMessage;

// 获取本地所有好友的列表
+ (NSArray *)getFriend;

@end
