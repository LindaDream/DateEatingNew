//
//  YRequestOurData.h
//  DateEating
//
//  Created by lanou3g on 16/7/26.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YRequestOurDataDelegate <NSObject>

- (void)getOurDataByCondition:(NSMutableArray *)array;

@end

@interface YRequestOurData : NSObject

singleton_interface(YRequestOurData);

@property (strong,nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) id<YRequestOurDataDelegate>delegate;

- (void)getOurDataWithDateType:(NSInteger)type gender:(NSInteger)gender time:(NSInteger)time age:(NSInteger)age constellation:(NSInteger)constellation;

@end
