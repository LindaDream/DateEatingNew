//
//  YFeeTypeModel.h
//  DateEating
//
//  Created by lanou3g on 16/7/12.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFeeTypeModel : NSObject

@property (strong, nonatomic) NSString *desc;   // 吃饭付费的方式
@property (strong, nonatomic) NSString *field;  // 英文表述
@property (assign, nonatomic) NSInteger value;  // 我请客值为1，AA为0

@end
