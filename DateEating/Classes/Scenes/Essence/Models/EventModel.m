//
//  EventModel.m
//  ShiYi
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import "EventModel.h"

@implementation EventModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
