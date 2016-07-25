//
//  YContent.h
//  DateEating
//
//  Created by lanou3g on 16/7/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YContent : NSObject

@property (strong,nonatomic) NSString *ownerId;

@property (strong,nonatomic) NSString *fromName;

@property (strong,nonatomic) NSString *toName;

@property (strong,nonatomic) NSDictionary *createdAt;

@property (strong,nonatomic) NSString *contents;


+ (void)parsesContentWithOwnerId:(NSString *)ownerId SuccessRequest:(successRequest)success failurRequest:(failureRequest)failure;
// 获取头像
+ (void)getContentAvatarWithUserName:(NSString *)userName SuccessRequest:(successRequest)success failurRequest:(failureRequest)failure;

@end
