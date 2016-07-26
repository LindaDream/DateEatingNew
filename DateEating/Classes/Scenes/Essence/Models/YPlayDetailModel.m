//
//  YPlayDetailModel.m
//  DateEating
//
//  Created by lanou3g on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YPlayDetailModel.h"

@implementation YPlayDetailModel

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


+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure{
    [YNetWorkRequestManager getRequestWithUrl:url successRequest:^(NSDictionary *dict) {
        if(dict){
            YPlayDetailModel *play = [[YPlayDetailModel alloc] init];
            [play setValuesForKeysWithDictionary:dict[@"data"]];
            success(play);
        }
    } failurRequest:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}


@end
