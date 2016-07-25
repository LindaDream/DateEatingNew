//
//  YUserDetailModel.h
//  DateEating
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDateContentModel.h"
#import "YHobby.h"
#import "YMovie.h"
#import "YRestaurant.h"
#import "YTravel.h"
#import "YVideo.h"

@interface YUserDetailModel : NSObject

@property (assign, nonatomic) NSInteger action;                 // 未知
@property (assign, nonatomic) NSInteger age;                    // 年龄
@property (assign, nonatomic) NSInteger alcohol;                // 是否喝酒
@property (strong, nonatomic) NSString *constellation;          // 星座
@property (assign, nonatomic) NSInteger dayChatCount;           //
@property (strong, nonatomic) NSString *district;               // 地区
@property (strong, nonatomic) YDateContentModel *event;////     // 正在发布的约会
@property (assign, nonatomic) NSInteger gender;                 // 性别
@property (assign, nonatomic) NSInteger height;                 // 身高
@property (strong, nonatomic) NSArray *hobby;///////////        // 爱好
@property (strong, nonatomic) NSString *isOfficial;
@property (assign, nonatomic) NSInteger joinedEvent_count;      // 已参加过的活动
@property (strong, nonatomic) NSString *lastOnlineTime;         // 上一次上线时间
@property (assign, nonatomic) CGFloat lat;                      // 纬度
@property (assign, nonatomic) CGFloat lng;                      // 经度
@property (assign, nonatomic) NSInteger marriage;               // 婚姻状况
@property (strong, nonatomic) NSArray *movie;//////////         // 喜欢的电影
@property (strong, nonatomic) NSString *nick;                   // 昵称
@property (assign, nonatomic) NSInteger occupation;             // 职业
@property (assign, nonatomic) NSInteger openingEvent_count;     // 正在进行的约会数
@property (strong, nonatomic) NSString *personalInfo;           // 个人签名
@property (strong, nonatomic) NSString *pics;                   // 图片
@property (assign, nonatomic) NSInteger recentContact;          //
@property (strong, nonatomic) NSString *role2;
@property (assign, nonatomic) NSInteger smoking;               // 是否吸烟
@property (strong, nonatomic) NSArray *travel;////////          // 想旅行的地方
@property (strong, nonatomic) YRestaurant *restaurant;/////     // 关注的餐厅
@property (assign, nonatomic) NSInteger userCared;
@property (assign, nonatomic) NSInteger userCaterCount;         // 关注的餐厅数
@property (assign, nonatomic) NSInteger userId;                 // 用户id
@property (strong, nonatomic) NSArray *video; //////            // 个人视频
@property (assign, nonatomic) NSInteger whether_is_black;


@end
