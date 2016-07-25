//
//  YActionUserModel.m
//  DateEating
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YActionUserModel.h"

@implementation YActionUserModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"role2"]) {
        _role2 = [NSString stringWithFormat:@"%@",value];
    }
    if ([key isEqualToString:@"nick"]) {
        _nick = [NSString stringWithFormat:@"%@",value];
    }
}

@end
