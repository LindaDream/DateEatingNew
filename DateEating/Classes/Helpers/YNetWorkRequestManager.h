//
//  YNetWorkRequestManager.h
//  DateEating
//
//  Created by lanou3g on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successRequest)(id dict);
typedef void(^failureRequest)(NSError *error);

@interface YNetWorkRequestManager : NSObject

+ (void)getRequestWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure;

@end
