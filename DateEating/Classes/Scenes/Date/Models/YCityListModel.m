//
//  YCityListModel.m
//  DateEating
//
//  Created by user on 16/7/17.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YCityListModel.h"

@implementation YCityListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", _city_name];
}
@end
