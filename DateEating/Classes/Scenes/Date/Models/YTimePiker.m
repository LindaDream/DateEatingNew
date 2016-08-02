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
    NSString *currentYear = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    currentYear = [formatter stringFromDate:[NSDate date]];
    for (int i = 0; i < 12; i++) {// 控制月份
        if (i == 0 || i == 2 || i == 4 || i == 6 || i == 7 || i == 9 || i == 11) {
            dayCount = 31;
        }else if (i == 1){
            dayCount = 29;
        }else{
            dayCount = 30;
        }
        for (int day = 1; day <= dayCount; day++) {// 控制日期
            if (day < 10) {
                NSString *dateStr = [NSString stringWithFormat:@"%@-%@-0%d",currentYear,monthArr[i],day];
                [dateArray addObject:dateStr];
            }else{
                NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%d",currentYear,monthArr[i],day];
                [dateArray addObject:dateStr];
            }
        }
    }
    for (int i = 0; i < dateArray.count; i++) {
        if (i < 3) {
            NSString *str = [dateArray[i] stringByAppendingString:week[i + 4]];
            [array addObject:str];
        }else{
            NSString *str = nil;
            if (i % 7 <= 6 && i % 7 >= 3) {
               str = [dateArray[i] stringByAppendingString:week[i % 7 - 3]];
            }else if(i % 7 >= 0 && i % 7 <= 2){
                str = [dateArray[i] stringByAppendingString:week[i % 7 + 4]];
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
    NSMutableArray *array = [NSMutableArray array];
    NSString *minuteStr = nil;
    for (int i = 0; i < 60; i++) {
        if (i < 10) {
            minuteStr = [NSString stringWithFormat:@"0%d",i];
        }else{
            minuteStr = [NSString stringWithFormat:@"%d",i];
        }
        [array addObject:minuteStr];
    }
    return  array;
}


@end
