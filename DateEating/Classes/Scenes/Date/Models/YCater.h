//
//  YCater.h
//  DateEating
//
//  Created by lanou3g on 16/7/16.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCater : NSObject

@property (assign, nonatomic) NSInteger action;         // 未知
@property (assign, nonatomic) NSInteger actionTime;     // 时间
@property (strong, nonatomic) NSString *address;        // 地址
@property (strong, nonatomic) NSString *avgPrice;       // 平均消费
@property (strong, nonatomic) NSString *branchName;     // 分店名
@property (strong, nonatomic) NSString *businessId;     // 餐厅编号
@property (strong, nonatomic) NSString *categories;     // 菜类别
@property (strong, nonatomic) NSString *categoriesStr;  //
@property (strong, nonatomic) NSString *city;           // 所在城市
@property (assign, nonatomic) NSInteger createTime;     // 创建时间
@property (assign, nonatomic) NSInteger id;             // id
@property (assign, nonatomic) float latitude;       // 纬度
@property (assign, nonatomic) float longitude;      // 经度
@property (strong, nonatomic) NSString *name;           // 店名
@property (strong, nonatomic) NSString *photoUrl;       // 图片大
@property (strong, nonatomic) NSString *platform;       //  平台
@property (strong, nonatomic) NSString *region;         // 区域
@property (strong, nonatomic) NSString *regions;        // 具体区域
@property (strong, nonatomic) NSString *regionsStr;     //
@property (strong, nonatomic) NSString *sPhotoUrl;      // 图片小
@property (strong, nonatomic) NSString *telephone;      // 电话
@property (strong, nonatomic) NSString *url;            // 大众点评链接

@end
