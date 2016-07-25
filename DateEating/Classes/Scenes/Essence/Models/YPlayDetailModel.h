//
//  YPlayDetailModel.h
//  DateEating
//
//  Created by lanou3g on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPlayDetailModel : NSObject

@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSString *cityName;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *duration;
@property (nonatomic, strong)NSString *ID;
@property (nonatomic, strong)NSString *mPicUrl;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSMutableArray *recommendAutomatic;
@property (nonatomic, strong)NSString *openUrl;

+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure;

@end
