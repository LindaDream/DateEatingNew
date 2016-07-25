//
//  YTimePiker.m
//  DateEating
//
//  Created by user on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YTimePiker.h"
@implementation YTimePiker

singleton_implementaton(YTimePiker);

-(NSArray *)dateArray{
    int dayCount = 0;
    NSMutableArray *dateArray = [NSMutableArray array];
    NSMutableArray *array = [NSMutableArray array];
    NSArray *monthArr = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    NSArray *week = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    for (int i = 0; i < 12; i++) {// 控制月份
        if (i == 0 || i == 2 || i == 4 || i == 6 || i == 7 || i == 9 || i == 11) {
            dayCount = 31;
        }else if (i == 1){
            dayCount = 29;
        }else{
            dayCount = 30;
        }
        for (int day = 1; day <= dayCount; day++) {// 控制日期
                NSString *dateStr = [NSString stringWithFormat:@"2016-%@-%d",monthArr[i],day];
                [dateArray addObject:dateStr];
        }
    }
    for (int i = 0; i < dateArray.count; i++) {
        if (i < 3) {
            NSString *str = [dateArray[i] stringByAppendingString:week[i + 4]];
            [array addObject:str];
        }else{
            NSString *str = nil;
            if (i % 7 - 3 >= 0) {
               str = [dateArray[i] stringByAppendingString:week[i % 7 - 3]];
            }else{
                str = [dateArray[i] stringByAppendingString:week[i % 7]];
            }
                [array addObject:str];
            }
        }
    return array;
}

-(NSArray *)hourArray{
    NSMutableArray *array = [NSMutableArray array];
    NSString *hourStr = nil;
    for (int i = 0; i < 24; i++) {
        if (i < 10) {
            hourStr = [NSString stringWithFormat:@"0%d",i];
        }else{
            hourStr = [NSString stringWithFormat:@"%d",i];
        }
        [array addObject:hourStr];
    }
    return  array;
}

-(NSArray *)minuteArray{
    NSArray *array = @[@"00",@"15",@"30",@"45"];
    return  array;
}

@end
