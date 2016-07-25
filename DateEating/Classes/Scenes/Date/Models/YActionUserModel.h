//
//  YActionUserModel.h
//  DateEating
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YActionUserModel : NSObject

@property (assign, nonatomic) NSInteger action;         //活动类型(暂时不知道是干啥的)，多数为1
@property (assign, nonatomic) NSInteger age;            // 年龄
@property (strong, nonatomic) NSString *constellation;  // 星座
@property (assign, nonatomic) NSInteger gender;         // 男为1，女为0
@property (assign, nonatomic) NSInteger height;         // 身高
@property (strong, nonatomic) NSString *isOfficial;     // 是公务员或官员 “0”不是“1”是
@property (strong, nonatomic) NSString *lastOnlineTime; // 上一次的上线时间
@property (assign, nonatomic) double lat;               // 纬度
@property (assign, nonatomic) double lng;               // 经度
@property (strong, nonatomic) NSString *nick;           // 昵称
@property (strong, nonatomic) NSString *role2;          // 不知道干啥用的。有时是字符串有时是整型*******
@property (assign, nonatomic) NSInteger userId;         // 用户的id
@property (strong, nonatomic) NSString *userImageUrl;   // 用户头像图片的url
@property (strong, nonatomic) NSString *userKey;        // 不知道干啥用的

@end
