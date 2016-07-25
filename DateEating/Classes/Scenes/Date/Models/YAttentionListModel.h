//
//  YAttentionList.h
//  DateEating
//
//  Created by user on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YAttentionListModel : NSObject
@property(assign,nonatomic)NSInteger action;
@property(assign,nonatomic)NSInteger age;
@property(assign,nonatomic)NSInteger gender;
@property(assign,nonatomic)NSInteger height;
@property(assign,nonatomic)NSInteger userId;
@property(assign,nonatomic)CGFloat lat;
@property(assign,nonatomic)CGFloat lng;
@property(strong,nonatomic)NSString *constellation;
@property(strong,nonatomic)NSString *isOfficial;
@property(strong,nonatomic)NSString *lastOnlineTime;
@property(strong,nonatomic)NSString *nick;
@property(strong,nonatomic)NSString *userImageUrl;
+ (void)parsesWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failur;
@end
