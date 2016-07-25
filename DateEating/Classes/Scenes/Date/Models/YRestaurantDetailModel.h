//
//  YRestaurantDetailModel.h
//  DateEating
//
//  Created by user on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRestaurantDetailModel : NSObject
// 名字
@property(strong,nonatomic)NSString *name;
// 人均价格
@property(strong,nonatomic)NSString *avgPrice;
// 类型
@property(strong,nonatomic)NSString *categoriesStr;
// 头像连接
@property(strong,nonatomic)NSString *sPhotoUrl;
// 电话
@property(strong,nonatomic)NSString *telephone;
// 关注人数
@property(assign,nonatomic)NSInteger caterUserCount;
// 地址
@property(strong,nonatomic)NSString *address;
// 参数
@property(strong,nonatomic)NSString *businessId;
// 经纬度
@property(assign,nonatomic)CGFloat latitude;
@property(assign,nonatomic)CGFloat longitude;

+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failur;
@end
