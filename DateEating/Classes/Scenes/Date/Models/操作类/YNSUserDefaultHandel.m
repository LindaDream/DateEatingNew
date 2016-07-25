//
//  YNSUserDefaultHandel.m
//  DateEating
//
//  Created by lanou3g on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YNSUserDefaultHandel.h"

@implementation YNSUserDefaultHandel

static YNSUserDefaultHandel *handle = nil;
+ (instancetype)sharedYNSUserDefaultHandel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[[self class]alloc]init];
    });
    return handle;
}



#pragma mark -- 保存值 --
- (void)setBasicCheck:(NSInteger)basicCheck {
    [[NSUserDefaults standardUserDefaults]setInteger:basicCheck forKey:@"basicCheck"];
}
- (void)setCity:(NSDictionary *)city {
    [[NSUserDefaults standardUserDefaults]setObject:city forKey:@"city"];
}
- (void)setMulti:(NSInteger)multi {
    [[NSUserDefaults standardUserDefaults]setInteger:multi forKey:@"multi"];
}
- (void)setGender:(NSInteger)gender {
    [[NSUserDefaults standardUserDefaults]setInteger:gender forKey:@"gender"];
}
- (void)setTime:(NSInteger)time {
    [[NSUserDefaults standardUserDefaults]setInteger:time forKey:@"time"];
}
- (void)setAge:(NSInteger)age {
    [[NSUserDefaults standardUserDefaults]setInteger:age forKey:@"age"];
}
- (void)setConstellation:(NSInteger)constellation {
    [[NSUserDefaults standardUserDefaults]setInteger:constellation forKey:@"constellation"];
}
- (void)setOccupation:(NSInteger)occupation {
    [[NSUserDefaults standardUserDefaults]setInteger:occupation forKey:@"occupation"];
}

//basicCheck=0&city=010&multi=0&gender=0&time=0&age=0&constellation=0&occupation=0&start=0&size=20&apiVersion=2.9.0
#pragma mark -- 存值 --
- (NSInteger)basicCheck {
    if (![[NSUserDefaults standardUserDefaults]integerForKey:@"basicCheck"]) {
        return 0;
    }
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"basicCheck"];
}

- (NSDictionary *)city {
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"city"]) {
        return @{@"北京":@010};
    }
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"city"];
}
- (NSInteger)multi {
    if (![[NSUserDefaults standardUserDefaults]integerForKey:@"multi"]) {
        return 0;
    }
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"multi"];
}
- (NSInteger)gender {
    if (![[NSUserDefaults standardUserDefaults]integerForKey:@"gender"]) {
        return 0;
    }
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"gender"];
}
- (NSInteger)time {
    if (![[NSUserDefaults standardUserDefaults]integerForKey:@"time"]) {
        return 0;
    }
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"time"];
}

- (NSInteger)age {
    if (![[NSUserDefaults standardUserDefaults]integerForKey:@"age"]) {
        return 0;
    }
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"age"];
}
- (NSInteger)constellation {
    if (![[NSUserDefaults standardUserDefaults]integerForKey:@"constellation"]) {
        return 0;
    }
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"constellation"];
}
- (NSInteger)occupation {
    if (![[NSUserDefaults standardUserDefaults]integerForKey:@"occupation"]) {
        return 0;
    }
    return [[NSUserDefaults standardUserDefaults]integerForKey:@"occupation"];
}

#pragma mark -- 将更改更新到磁盘 --
- (void)synchronize
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -- 重置所选条件 --
- (void)reSetCondition {
    [self setAge:0];
    [self setConstellation:0];
    [self setMulti:0];
    [self setTime:0];
    [self setOccupation:0];
    [self setGender:0];
}

#pragma mark -- 是否有筛选条件 --
- (BOOL)haveSeekCondition {
    NSInteger num = [self age] + [self constellation] + [self multi] + [self time] + [self occupation] + [self gender];
    if (num > 0) {
        return YES;
    }else {
        return NO;
    }
}

@end

