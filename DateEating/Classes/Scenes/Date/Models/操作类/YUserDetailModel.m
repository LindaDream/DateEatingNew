//
//  YUserDetailModel.m
//  DateEating
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YUserDetailModel.h"

@implementation YUserDetailModel

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"event"]) {
        _event = [[YDateContentModel alloc]init];
        [_event setValuesForKeysWithDictionary:value];
    } else if ([key isEqualToString:@"hobby"]) {
        NSMutableArray *arr = [NSMutableArray array];
        NSArray *array = value;
        for (NSDictionary *dic in array) {
            YHobby *hobby = [[YHobby alloc]init];
            [hobby setValuesForKeysWithDictionary:dic];
            [arr addObject:hobby];
        }
        _hobby = arr;
    } else if ([key isEqualToString:@"movie"]) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            YMovie *hobby = [[YMovie alloc]init];
            [hobby setValuesForKeysWithDictionary:dic];
            [arr addObject:hobby];
        }
        _movie = arr;
    } else if ([key isEqualToString:@"restaurant"]) {
        _restaurant = [[YRestaurant alloc]init];
        [_restaurant setValuesForKeysWithDictionary:value];
    } else if ([key isEqualToString:@"travel"]) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            YTravel *hobby = [[YTravel alloc]init];
            [hobby setValuesForKeysWithDictionary:dic];
            [arr addObject:hobby];
        }
        _travel = arr;
    } else if ([key isEqualToString:@"video"]) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in value) {
            YVideo *hobby = [[YVideo alloc]init];
            [hobby setValuesForKeysWithDictionary:dic];
            [arr addObject:hobby];
        }
        _video = arr;
    }else if ([key isEqualToString:@"role2"]) {
        _role2 = [NSString stringWithFormat:@"%@",value];
    }else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
