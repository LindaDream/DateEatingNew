//
//  MealModel.h
//  ShiYi
//
//  Created by lanou3g on 15/10/27.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMealModel : NSObject

@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSString *businessesDistrict;
@property (nonatomic, strong)NSString *contactNumber;
@property (nonatomic, strong)NSString *hostName;
@property (nonatomic, assign)NSInteger ID;
@property (nonatomic, strong)NSString *picUrl;
@property (nonatomic, assign)CGFloat price;
@property (nonatomic, strong)NSString *priceStr;
@property (nonatomic, strong)NSMutableArray *tags;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *viceTitle;
@property (nonatomic, assign)BOOL isShow;
@property (strong,nonatomic) NSNumber *nextPage;
@property (strong,nonatomic) NSNumber *page;
@property (strong,nonatomic) NSString *rows;

+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure;

@end
