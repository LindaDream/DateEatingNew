//
//  CityModel.h
//  ShiYi
//
//  Created by lanou3g on 15/10/27.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCityModel : NSObject

@property (nonatomic, assign)NSInteger baseCityId;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSMutableArray *tabs;

+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure;
@end


