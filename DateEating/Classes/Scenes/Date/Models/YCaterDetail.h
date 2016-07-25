//
//  YCaterDetail.h
//  DateEating
//
//  Created by lanou3g on 16/7/16.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCater.h"

@interface YCaterDetail : NSObject

@property (assign, nonatomic) NSInteger caterUserCount;     // 关注次餐厅的人
@property (assign, nonatomic) NSInteger finishEventCount;   // 已经完成的约会
@property (assign, nonatomic) NSInteger openingEventCount;  // 正在进行中的约会
@property (assign, nonatomic) NSInteger status;             // 未知
@property (assign, nonatomic) NSInteger userContentCount;   // 约饭留言数

@property (strong, nonatomic) YCater *cater;

@end
