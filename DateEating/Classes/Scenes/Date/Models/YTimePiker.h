//
//  YTimePiker.h
//  DateEating
//
//  Created by user on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTimePiker : NSObject

singleton_interface(YTimePiker);

// 约会的日期
- (NSArray *)dateArray;
// 小时数组
- (NSArray *)hourArray;
// 分数组
- (NSArray *)minuteArray;
@end
