//
//  YRequestOurData.m
//  DateEating
//
//  Created by lanou3g on 16/7/26.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YRequestOurData.h"
#import "YDateContentModel.h"
#import "YContent.h"
#import "YChatMessageModel.h"

@interface YRequestOurData ()
@property (assign, nonatomic) NSInteger date123;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) NSDateFormatter *formatter1;
@end

@implementation YRequestOurData

singleton_implementaton(YRequestOurData)

- (void)getOurDataWithDateType:(NSInteger)type gender:(NSInteger)gender time:(NSInteger)time age:(NSInteger)age constellation:(NSInteger)constellation {
    
    self.date123 = [[NSDate date] timeIntervalSince1970]*1000;
    self.formatter = [NSDateFormatter new];
    [self.formatter setDateFormat:@"YYYY-MM-dd HH : mm"];
    self.formatter1 = [NSDateFormatter new];
    [self.formatter1 setDateFormat:@"YYYY-MM-dd"];
    
    NSString *genderStr = nil;
    if (gender == 1) {
        genderStr = @"0";
    } else if(gender == 2) {
        genderStr = @"1";
    }
    
    NSInteger smallAge = 0;
    NSInteger bigAge = 0;
    if (age == 1) {
        smallAge = 18;
        bigAge = 22;
    } else if(age == 2){
        smallAge = 23;
        bigAge = 26;
    } else if(age == 3){
        smallAge = 27;
        bigAge = 35;
    }else if(age == 4){
        smallAge = 35;
        bigAge = 0;
    }
    NSArray *array = array1;
    NSString *constellationStr = array[constellation];
    
    if (type == 0) {
        [self getOurData:@"MyDate" time:time gender:genderStr smallAge:smallAge bigAge:bigAge constellation:constellationStr];
        [self getOurData:@"MyParty" time:time gender:genderStr smallAge:smallAge bigAge:bigAge constellation:constellationStr];
    } else if (type == 1){
        [self getOurData:@"MyDate" time:time gender:genderStr smallAge:smallAge bigAge:bigAge constellation:constellationStr];
    } else {
        [self getOurData:@"MyParty" time:time gender:genderStr smallAge:smallAge bigAge:bigAge constellation:constellationStr];
    }

}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)getOurData:(NSString *)className time:(NSInteger)time gender:(NSString *)genderStr smallAge:(NSInteger)smallAge bigAge:(NSInteger)bigAge constellation:(NSString *)constellationStr {
    
    __weak typeof(self) weakSelf = self;
    AVQuery *OurQuery = [AVQuery queryWithClassName:className];
    [OurQuery whereKey:@"Our" equalTo:@"Our"];
    // 开始查询
    [OurQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count != 0) {
            [weakSelf.dataArray removeAllObjects];
            for (AVObject *object in objects) {
                NSDictionary *dict = [object dictionaryForObject];
                YDateContentModel *model = [YDateContentModel new];
                model.eventName = [dict objectForKey:@"theme"];
                model.eventLocation = [dict objectForKey:@"address"];
                model.dateTime = [dict objectForKey:@"time"];
                
                // 判断时间是够符合标准
                NSString *str1 = [model.dateTime substringToIndex:10];
                NSString *str2 = [model.dateTime substringFromIndex:12];
                
                NSString *str = [NSString stringWithFormat:@"%@ %@",str1,str2];
                NSDate *dateTime = [self.formatter dateFromString:str];
                NSInteger qwer = [dateTime timeIntervalSince1970]*1000;
                if (qwer < self.date123) {
                    continue;
                }
                
                // 判断时间是否满足条件
                if (time != 0) {
                    NSString *ourDate = [model.dateTime substringToIndex:10];
                    NSDate *dateToString = [self.formatter1 dateFromString:ourDate];
                    
                    NSString *string = [self.formatter1 stringFromDate:[NSDate date]];
                    NSDate *dateFromString = [self.formatter1 dateFromString:string];
                    
                    
                    NSLog(@"%@",dateFromString);
                    NSLog(@"%@",dateToString);
                    
                    NSInteger timediff = [dateToString timeIntervalSince1970]-[dateFromString timeIntervalSince1970] + 1000;
                    NSLog(@"%ld",timediff);
                    NSInteger dayCount = timediff/86400;
                    NSLog(@"%ld",dayCount);
                    if (time == 1) {
                        if (dayCount != 0) {
                            continue;
                        }
                    } else if (time == 2) {
                        if (dayCount != 1) {
                            continue;
                        }
                    } else if (time == 3) {
                        if (dayCount < 2) {
                            continue;
                        }
                    }
                }
                model.ourSeverMark = @"Our";
                model.eventDescription = [dict objectForKey:@"description"];
                model.caterBusinessId = [dict objectForKey:@"businessID"];
                
                if ([className isEqualToString:@"MyDate"]) {
                    model.eventObject = [dict objectForKey:@"dateObject"];
                } else {
                    model.eventObject = [NSString stringWithFormat:@"邀请%@",[dict objectForKey:@"partyCount"]];
                }
                if ([[dict objectForKey:@"concrete"] isEqualToString:@"我请客"]) {
                    model.fee = 0;
                }else{
                    model.fee = 1;
                }
                model.user = [[YActionUserModel alloc]init];
                model.user.nick = [dict objectForKey:@"userName"];
                NSLog(@"%@",model.user.nick);
                // 判断用户是否符合要求
                BOOL __block conformToCondition = YES;
                AVQuery *query1 = [AVQuery queryWithClassName:@"_User"];
                [query1 whereKey:@"username" equalTo:model.user.nick];
                [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (objects.count != 0) {
                        
                        AVObject *user11 = objects[0];
                        AVFile *file = [user11 objectForKey:@"avatar"];
                        model.user.userImageUrl = file.url;
                        
                        NSDictionary *userDic = [objects.firstObject dictionaryForObject];
                        NSString *gender = [userDic objectForKey:@"gender"];
                        if (genderStr != nil) {
                            if (![gender isEqualToString:genderStr]) {
                                conformToCondition = NO;
                            }
                        }
                        model.user.gender = gender.integerValue;
                        NSString *age = [userDic objectForKey:@"age"];
                        if (smallAge == 0 && bigAge == 0) {
                            
                        } else if (smallAge == 35 && bigAge == 0) {
                            if (age.integerValue <= 35) {
                                conformToCondition = NO;
                            }
                        } else {
                            if (!(age.integerValue >= smallAge && age.integerValue <= bigAge)) {
                                conformToCondition = NO;
                            }
                        }
                        model.user.age = age.integerValue;
                        NSString *constellation = [userDic objectForKey:@"constellation"];
                        if (![constellationStr isEqualToString:@"不限"]) {
                            if (![constellation isEqualToString:constellationStr]) {
                                conformToCondition = NO;
                            }
                        }
                        model.user.constellation = constellation;
                        NSString *eventId = [NSString stringWithFormat:@"%@%@",model.user.nick,model.dateTime];
                        
                        AVQuery *query2 = [AVQuery queryWithClassName:@"eventCount"];
                        [query2 whereKey:@"eventId" equalTo:eventId];
                        [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            if (error == nil) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                model.commentCount = objects.count;
                                if (conformToCondition) {
                                    [self.dataArray addObject:model];
                                    [self reloadData];
                                }
                                });
                            }
                        }];
                    }
                }];
            }
        }
    }];
}

- (void)reloadData {
    if (_delegate && [_delegate respondsToSelector:@selector(getOurDataByCondition:)]) {
        [_delegate getOurDataByCondition:self.dataArray];
    }
}




@end
