//
//  YDateContentModel.h
//  DateEating
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YActionUserModel.h"
#import "YFeeTypeModel.h"

@interface YDateContentModel : NSObject


@property (assign, nonatomic) NSInteger action;         // 活动的类型，多为0
@property (assign, nonatomic) NSInteger actionTime;     // 活动的发起时间
@property (assign, nonatomic) NSInteger candidateCount; // 报名的人数
@property (strong, nonatomic) NSString *caterAvgPrice;  // 人均消费
@property (strong, nonatomic) NSString *caterBranchName;// 分店名
@property (strong, nonatomic) NSString *caterBusinessId;// 餐厅编号
@property (strong, nonatomic) NSString *caterCategories;// 食物类型
@property (strong, nonatomic) NSString *caterCity;      // 餐馆所在城市
@property (strong, nonatomic) NSString *caterPhotoUrl;  // 餐厅或食物图片展示(大)
@property (strong, nonatomic) NSString *caterSPhotoUrl; // 餐厅或食物图片(小)
@property (strong, nonatomic) NSString *caterPlatform;  // 平台类型(不太清楚)多为1******
@property (strong, nonatomic) NSString *caterRegions;   // 餐厅所在区域
@property (assign, nonatomic) NSInteger caterShopId;    // 餐厅ID
@property (strong, nonatomic) NSString *caterTelephone; // 餐厅电话
@property (assign, nonatomic) NSInteger clientStamp;    // 未知
@property (assign, nonatomic) NSInteger commentCount;   // 评论人数
@property (assign, nonatomic) NSInteger createTime;     // 创建时间
@property (assign, nonatomic) NSInteger credit;         // 信用值
@property (strong, nonatomic) NSString *deviceModel;    // 设备类型
@property (strong, nonatomic) NSString *eventAddress;   // 活动的地点
@property (strong, nonatomic) NSString *eventCity;      // 活动所在城市代码
@property (strong, nonatomic) NSString *eventCityName;  // 城市名
@property (assign, nonatomic) NSInteger eventDateTime;  // 活动的具体开始时间
@property (strong, nonatomic) NSString *eventDescription;// 活动的描述
@property (assign, nonatomic) NSInteger eventExpense;   // 活动人均开销
@property (strong, nonatomic) NSString *eventKey;       // 未知
@property (assign, nonatomic) CGFloat eventLatitude;    // 活动地点纬度;
@property (assign, nonatomic) CGFloat eventLongitude;   // 经度
@property (strong, nonatomic) NSString *eventLocation;  // 店名或地点
@property (strong, nonatomic) NSString *eventLocationUrl;// 店铺详细信息链接
@property (strong, nonatomic) NSString *eventName;      // 活动主题
@property (strong, nonatomic) NSString *eventRegion;    // 活动地点所在区域
@property (assign, nonatomic) NSInteger fee;            // 付费类型，1是请客，0是AA
@property (strong, nonatomic) YFeeTypeModel *feeType;    // 付费类型陈述对象
@property (assign, nonatomic) NSInteger ID;             // 该活动的ID
@property (assign, nonatomic) BOOL isMark;              // 应该是什么的标记
@property (assign, nonatomic) NSInteger multi;          // 0 是双人聚餐，1是多人
@property (assign, nonatomic) NSInteger opposite;       // 反对的数量
@property (assign, nonatomic) NSInteger rechargeCred;   // 所垫付的信用值
@property (assign, nonatomic) double score;             // 评分
@property (assign, nonatomic) NSInteger showCount;      // 看过的人
@property (assign, nonatomic) NSInteger state;          // 是否在约会
@property (strong, nonatomic) NSString *url;            // 活动详情链接
@property (strong, nonatomic) YActionUserModel *user;   // 活动发起者的详细信息
@property (assign, nonatomic) NSInteger userId;         // 活动发起者id
@property (assign, nonatomic) NSInteger visitorState;   // 访问状态

// 活动详情页多出来的数据
@property (assign, nonatomic) NSInteger dayChatCount;
@property (assign, nonatomic) NSInteger guarantee;
@property (assign, nonatomic) NSInteger guaranteeCred;
@property (assign, nonatomic) NSInteger rankNumber;
@property (assign, nonatomic) NSInteger recentContact;

// 自己的数据
@property (strong, nonatomic) NSString *dateTime;       // 约会时间（字符串格式）
@property (strong, nonatomic) NSString *ourSeverMark;         // 我们自己的服务器的标记
@property(strong,nonatomic)NSString *creatAt;
@property (strong, nonatomic) UIImage *img;
@property (strong, nonatomic) NSString *eventObject;     // 约会/聚会的对象

+ (NSMutableArray *)getDateContentListWithDic:(NSDictionary *)dict;

@end
