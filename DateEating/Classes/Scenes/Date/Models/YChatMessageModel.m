//
//  YChatMessageModel.m
//  DateEating
//
//  Created by lanou3g on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YChatMessageModel.h"

@implementation YChatMessageModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"ID"];
    }
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"replyUser"]) {
        _replyUser = [[YActionUserModel alloc]init];
        [_replyUser setValuesForKeysWithDictionary:value];
    } else if ([key isEqualToString:@"user"]) {
        _user = [[YActionUserModel alloc]init];
        [_user setValuesForKeysWithDictionary:value];
    } else {
        [super setValue:value forKey:key];
    }
}

+ (NSMutableArray *)getDateContentListWithDic:(NSDictionary *)dict {
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dictionary = dict[@"data"];
    for (NSDictionary *modelDic in dictionary[@"results"]) {
        YChatMessageModel *model = [[YChatMessageModel alloc]init];
        [model setValuesForKeysWithDictionary:modelDic];
        [array addObject:model];
    }
    return array;
}

@end
