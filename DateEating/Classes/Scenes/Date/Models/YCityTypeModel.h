//
//  YCityListModel.h
//  DateEating
//
//  Created by user on 16/7/17.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YCityListModel.h"
@interface YCityTypeModel : NSObject
@property (nonatomic, strong) NSString *begin_key;
@property (nonatomic, strong) NSMutableArray *city_list;

+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failur;
@end
