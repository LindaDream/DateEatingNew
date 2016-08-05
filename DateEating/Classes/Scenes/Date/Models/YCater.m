//
//  YCater.m
//  DateEating
//
//  Created by user on 16/7/16.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YCater.h"

@implementation YCater

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forUndefinedKey:@"ID"];
    }
}

@end
