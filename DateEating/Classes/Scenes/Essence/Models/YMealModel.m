//
//  MealModel.m
//  ShiYi
//
//  Created by lanou3g on 15/10/27.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import "YMealModel.h"

@implementation YMealModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = [value integerValue];
    }
}


+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure{
    
    NSMutableArray *mArr = [NSMutableArray array];
    [YNetWorkRequestManager getRequestWithUrl:url successRequest:^(NSDictionary *dict) {
        //NSLog(@"+++++++++++++%@",dict);
        if(dict){
            for (NSDictionary *dic in dict[@"data"][@"doc"]) {
                
                YMealModel *meal = [[YMealModel alloc] init];
                [meal setValuesForKeysWithDictionary:dic];
                meal.nextPage = dict[@"data"][@"nextPage"];
                meal.rows = dict[@"data"][@"totalRows"];
                
                NSLog(@"nextPage = %@ rows = %@",meal.nextPage,meal.rows);
                [mArr addObject:meal];
            }
            success(mArr);
            
        }
        
    } failurRequest:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}



@end
