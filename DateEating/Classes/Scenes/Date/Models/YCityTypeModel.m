//
//  YCityListModel.m
//  DateEating
//
//  Created by user on 16/7/17.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YCityTypeModel.h"

@implementation YCityTypeModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", _begin_key];
}


+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure{
    NSMutableArray *mArr = [NSMutableArray array];
    [YNetWorkRequestManager getRequestWithUrl:url successRequest:^(NSDictionary *dict) {
        //NSLog(@"+++++++++++++%@",dict);
        if(dict){
            for (NSDictionary *dic in dict[@"result"]) {
                YCityTypeModel *model = [[YCityTypeModel alloc] init];
                [model setValue:dic[@"begin_key"] forKey:@"begin_key"];
                NSMutableArray *tmpArr = [NSMutableArray new];
                for (NSDictionary *tempDic in dic[@"city_list"]) {
                    YCityListModel *cityModel = [YCityListModel new];
                    [cityModel setValuesForKeysWithDictionary:tempDic];
                    [tmpArr addObject:cityModel];
                }
                NSLog(@"%@",tmpArr);
                [model setValue:tmpArr forKey:@"city_list"];
                [mArr addObject:model];
            }
            success(mArr);
        }
    } failurRequest:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
