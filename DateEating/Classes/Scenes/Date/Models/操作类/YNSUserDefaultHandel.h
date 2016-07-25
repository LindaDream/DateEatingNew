//
//  YNSUserDefaultHandel.h
//  DateEating
//
//  Created by lanou3g on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YNSUserDefaultHandel : NSObject

+ (instancetype)sharedYNSUserDefaultHandel;

- (void)setBasicCheck:(NSInteger)basicCheck;
- (void)setMulti:(NSInteger)multi;
- (void)setGender:(NSInteger)gender;
- (void)setTime:(NSInteger)time;
- (void)setAge:(NSInteger)age;
- (void)setConstellation:(NSInteger)constellation;
- (void)setOccupation:(NSInteger)occupation;
- (void)setCity:(NSDictionary *)city;

- (NSInteger)basicCheck;
- (NSInteger)multi;
- (NSInteger)gender;
- (NSInteger)time;
- (NSInteger)age;
- (NSInteger)constellation;
- (NSInteger)occupation;
- (NSDictionary *)city;

- (void)synchronize;
- (void)reSetCondition;
- (BOOL)haveSeekCondition;

@end
