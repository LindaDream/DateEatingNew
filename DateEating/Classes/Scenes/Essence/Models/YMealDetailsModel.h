//
//  MealDetailsModel.h
//  ShiYi
//
//  Created by lanou3g on 15/11/1.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMealDetailsModel : NSObject

@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSString *businessesDistrict;
@property (nonatomic, strong)NSString *contactNumber;
@property (nonatomic, strong)NSString *Description;
@property (nonatomic, strong)NSString *guideline;
@property (nonatomic, strong)NSMutableArray *headPics;
@property (nonatomic, strong)NSString *highlight;
@property (nonatomic, strong)NSString *hostName;
@property (nonatomic, strong)NSString *ID;
@property (nonatomic, strong)NSString *interestedNum;
@property (nonatomic, strong)NSString *menu;
@property (nonatomic, strong)NSString *originalPrice;
@property (nonatomic, strong)NSString *picUrl;
@property (nonatomic, strong)NSString *price;
@property (nonatomic, strong)NSString *priceStr;
@property (nonatomic, strong)NSString *refundDesc;
@property (nonatomic, strong)NSString *saleNum;
@property (nonatomic, strong)NSMutableArray *tags;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *viceTitle;
@property (nonatomic, strong)NSMutableArray *recommendAutomatic;
@property (nonatomic, strong)NSString *shareUrl;

+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure;

@end
