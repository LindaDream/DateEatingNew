//
//  PlayModel.h
//  ShiYi
//
//  Created by lanou3g on 15/10/28.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPlayModel : NSObject

@property (nonatomic, strong)NSString *applyExpiredTime;
@property (nonatomic, strong)NSString *categoryIconUrl;
@property (nonatomic, strong)NSString *category;
@property (nonatomic, strong)NSString *categoryId;
@property (nonatomic, strong)NSString *cityName;
@property (nonatomic, strong)NSString *dataType;
@property (nonatomic, strong)NSString *duration;
@property (nonatomic, assign)NSInteger ID;
@property (nonatomic, strong)NSString *isFree;
@property (nonatomic, strong)NSString *neededCredits;
@property (nonatomic, strong)NSString *picUrl;
@property (nonatomic, strong)NSString *recommand;
@property (nonatomic, strong)NSString *tag;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, assign)BOOL isShow;
@property (strong,nonatomic) NSNumber *nextPage;
@property (strong,nonatomic) NSNumber *page;
@property (strong,nonatomic) NSString *rows;

+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure;
@end
