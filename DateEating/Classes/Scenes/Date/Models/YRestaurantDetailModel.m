//
//  YRestaurantDetailModel.m
//  DateEating
//
//  Created by user on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YRestaurantDetailModel.h"

@implementation YRestaurantDetailModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure{
    //NSMutableArray *mArr = [NSMutableArray array];
    [YNetWorkRequestManager getRequestWithUrl:url successRequest:^(NSDictionary *dict) {
        //NSLog(@"+++++++++++++%@",dict);
        if(dict){
                YRestaurantDetailModel *model = [[YRestaurantDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:dict[@"data"][@"cater"]];
            success(model);
        }
        
    } failurRequest:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
