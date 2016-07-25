//
//  YRestaurantListModel.h
//  DateEating
//
//  Created by user on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRestaurantListModel : NSObject
// 餐厅名
@property(strong,nonatomic)NSString *name;
// 人均价格
@property(strong,nonatomic)NSString *avgPrice;
// 地点
@property(strong,nonatomic)NSString *regionsStr;
// 类型
@property(strong,nonatomic)NSString *categoriesStr;
// 关注人数
@property(assign,nonatomic)NSInteger caterUserCount;
// 头像连接
@property(strong,nonatomic)NSString *sPhotoUrl;
@property(strong,nonatomic)NSString *businessId;
@property(strong,nonatomic)NSString *city;

+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failur;

@end
