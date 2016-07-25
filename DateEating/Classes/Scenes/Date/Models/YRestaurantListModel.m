//
//  YRestaurantListModel.m
//  DateEating
//
//  Created by user on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YRestaurantListModel.h"

@implementation YRestaurantListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure{
    NSMutableArray *mArr = [NSMutableArray array];
    [YNetWorkRequestManager getRequestWithUrl:url successRequest:^(NSDictionary *dict) {
       // NSLog(@"+++++++++++++%@",dict);
        if(dict){
            for (NSDictionary *dic in dict[@"data"][@"results"]) {
                YRestaurantListModel *model = [[YRestaurantListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [mArr addObject:model];
            }
            success(mArr);
        }
        
    } failurRequest:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
@end
