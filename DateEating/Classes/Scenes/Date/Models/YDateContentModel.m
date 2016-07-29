//
//  YDateContentModel.m
//  DateEating
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YDateContentModel.h"

@implementation YDateContentModel

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"user"]) {
        self.user = [[YActionUserModel alloc]init];
        [_user setValuesForKeysWithDictionary:value];
    } else if ([key isEqualToString:@"feeType"]) {
        self.feeType = [[YFeeTypeModel alloc]init];
        [_feeType setValuesForKeysWithDictionary:value];
    } else if ([key isEqualToString:@"caterPlatform"]) {
        self.caterPlatform = [NSString stringWithFormat:@"%@",value];
    } else {
        [super setValue:value forKey:key];
    }
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"ID"];;
    } 
}

+ (NSMutableArray *)getDateContentListWithDic:(NSDictionary *)dict {
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dictionary = dict[@"data"];
    for (NSDictionary *modelDic in dictionary[@"results"]) {
        YDateContentModel *model = [[YDateContentModel alloc]init];
        [model setValuesForKeysWithDictionary:modelDic];
        [array addObject:model];
    }
    return array;
}

@end
