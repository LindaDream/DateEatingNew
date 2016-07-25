//
//  PlayModel.m
//  ShiYi
//
//  Created by lanou3g on 15/10/28.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import "YPlayModel.h"

@implementation YPlayModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = [value intValue];
    }
    if ([key isEqualToString:@"categoryId"]) {
        self.categoryId = value;
    }
    if ([key isEqualToString:@"dataType"]) {
        self.dataType = value;
    }
    if ([key isEqualToString:@"isFree"]) {
        self.isFree = value;
    }
    if ([key isEqualToString:@"recommand"]) {
        self.recommand = value;
    }
    if ([key isEqualToString:@"categoryIconUrl"]) {
        if([value rangeOfString:@"outdoor_travel"].location !=NSNotFound)//_roaldSearchText
        {
            self.category = @"outdoor_travel";
        }
        if([value rangeOfString:@"art"].location !=NSNotFound)//_roaldSearchText
        {
            self.category = @"art";
        }
        if([value rangeOfString:@"other"].location !=NSNotFound)//_roaldSearchText
        {
            self.category = @"other";
        }
        if([value rangeOfString:@"fashion"].location !=NSNotFound)//_roaldSearchText
        {
            self.category = @"fashion";
        }
        if([value rangeOfString:@"good_wine"].location !=NSNotFound)//_roaldSearchText
        {
            self.category = @"good_wine";
        }
        if([value rangeOfString:@"education"].location !=NSNotFound)//_roaldSearchText
        {
            self.category = @"education";
        }
    }
}

+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure{
    
    NSMutableArray *mArr = [NSMutableArray array];
    [YNetWorkRequestManager getRequestWithUrl:url successRequest:^(NSDictionary *dict) {
        //NSLog(@"+++++++++++++%@",dict);
        //NSLog(@"%@",dict[@"data"][@"nextPage"]);
        if(dict != nil){
            for (NSDictionary *dic in dict[@"data"][@"doc"]) {
                
                YPlayModel *play = [[YPlayModel alloc] init];
                [play setValuesForKeysWithDictionary:dic];
                play.nextPage = dict[@"data"][@"nextPage"];
                play.page = dic[@"data"][@"page"];
                //NSLog(@"%@",dict[@"data"][@"nextPage"]);
                play.rows = dict[@"data"][@"totalRows"];
                [mArr addObject:play];
            }
            success(mArr);
        }
        
    } failurRequest:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}


@end
