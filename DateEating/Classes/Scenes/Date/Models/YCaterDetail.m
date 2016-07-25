//
//  YCaterDetail.m
//  DateEating
//
//  Created by lanou3g on 16/7/16.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YCaterDetail.h"

@implementation YCaterDetail

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"cater"]) {
        _cater = [[YCater alloc]init];
        [_cater setValuesForKeysWithDictionary:value];
    } else {
        [super setValue:value forKey:key];
    }
}


@end
