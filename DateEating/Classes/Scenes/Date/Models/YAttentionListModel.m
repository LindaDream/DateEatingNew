//
//  YAttentionList.m
//  DateEating
//
//  Created by user on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YAttentionListModel.h"

@implementation YAttentionListModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure{
    NSMutableArray *mArr = [NSMutableArray array];
    [YNetWorkRequestManager getRequestWithUrl:url successRequest:^(NSDictionary *dict) {
        NSLog(@"+++++++++++++%@",dict);
        if(dict){
            for (NSDictionary *dic in dict[@"data"][@"results"]) {
                YAttentionListModel *model = [[YAttentionListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic[@"user"]];
                NSLog(@"%@",model);
                [mArr addObject:model];
            }
            success(mArr);
        }
    } failurRequest:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.nick];
}
@end
