//
//  CityModel.m
//  ShiYi
//
//  Created by lanou3g on 15/10/27.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import "YCityModel.h"

@implementation YCityModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure{
    
    NSMutableArray *mArr = [NSMutableArray array];
    [YNetWorkRequestManager getRequestWithUrl:url successRequest:^(NSDictionary *dict) {
        //NSLog(@"+++++++++++++%@",dict);
        if(dict){
            for (NSDictionary *dic in dict[@"data"][@"allCity"]) {
                
                YCityModel *city = [[YCityModel alloc] init];
                [city setValuesForKeysWithDictionary:dic];
                [mArr addObject:city];
            }
            success(mArr);
        }
        
    } failurRequest:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}


@end






