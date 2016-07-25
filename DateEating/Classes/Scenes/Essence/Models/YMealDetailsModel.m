//
//  MealDetailsModel.m
//  ShiYi
//
//  Created by lanou3g on 15/11/1.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import "YMealDetailsModel.h"

@implementation YMealDetailsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"description"]) {
        self.Description = value;
    }
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    if ([key isEqualToString:@"interestedNum"]) {
        self.interestedNum = value;
    }
    if ([key isEqualToString:@"price"]) {
        self.interestedNum = value;
    }
    if ([key isEqualToString:@"saleNum"]) {
        self.saleNum = value;
    }
}

+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure{
    
    //NSMutableArray *mArr = [NSMutableArray array];
    [YNetWorkRequestManager getRequestWithUrl:url successRequest:^(NSDictionary *dict) {
        //NSLog(@"+++++++++++++%@",dict);
        if(dict){
            YMealDetailsModel *meal = [[YMealDetailsModel alloc] init];
            [meal setValuesForKeysWithDictionary:dict[@"data"]];
            //[mArr addObject:play];
            success(meal);
        }
        
    } failurRequest:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}


@end
