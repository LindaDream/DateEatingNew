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


@implementation YRequestOurData

singleton_implementaton(YRequestOurData)

- (void)getOurDataWithDateType:(NSInteger)type gender:(NSInteger)gender time:(NSInteger)time age:(NSInteger)age constellation:(NSInteger)constellation {
    
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
                // 判断时间是否满足条件
                if (time != 0) {
                    NSDate *timeDate = [NSDate date];
                    NSCalendar  * cal=[NSCalendar currentCalendar];
                    NSUInteger  unitFlags = NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
                    NSDateComponents * conponent= [cal components:unitFlags fromDate:timeDate];
                    NSString *nowDate = [NSString stringWithFormat:@"%ld-%ld-%ld",[conponent year],[conponent month],[conponent day]];
                    NSString *ourDate = [model.dateTime substringToIndex:9];
                    NSLog(@"%@",ourDate);
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                    NSDate *dateFromString = [dateFormatter dateFromString:nowDate];
                    NSDate *dateToString = [dateFormatter dateFromString:ourDate];
                    
                    NSInteger timediff = [dateToString timeIntervalSince1970]-[dateFromString timeIntervalSince1970] + 1000;
                    NSInteger dayCount = timediff/86400;
                    NSLog(@"%ld",dayCount);
                    if (time == 1) {
                        if (dayCount != 0) {
                            break;
                        }
                    } else if (time == 2) {
                        if (dayCount != 1) {
                            break;
                        }
                    } else if (time == 3) {
                        if (dayCount < 2) {
                            break;
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
                
                // 判断用户是否符合要求
                BOOL __block conformToCondition = YES;
                AVQuery *query = [AVQuery queryWithClassName:@"_User"];
                [query whereKey:@"username" equalTo:model.user.nick];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (objects.count != 0) {
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
                        
                        [YContent getContentAvatarWithUserName:model.user.nick SuccessRequest:^(id dict) {
                            model.user.userImageUrl = dict;
                            
                            NSString *eventId = [NSString stringWithFormat:@"%@%@",model.user.nick,model.dateTime];
                            NSMutableArray *__block array = [NSMutableArray array];
                            AVQuery *query = [AVQuery queryWithClassName:@"eventCount"];
                            [query whereKey:@"eventId" equalTo:eventId];
                            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                if (objects.count != 0) {
                                    for (AVObject *object in objects) {
                                        NSDictionary *dict = [object dictionaryForObject];
                                        YChatMessageModel *model = [YChatMessageModel new];
                                        model.isOurData = YES;
                                        model.user = [YActionUserModel new];
                                        model.user.nick = [dict objectForKey:@"user"];
                                        NSString *replayUserName = [dict objectForKey:@"replayUser"];
                                        if (![replayUserName isEqualToString:model.user.nick]) {
                                            model.replyUser = [YActionUserModel new];
                                            model.replyUser.nick = replayUserName;
                                        }
                                        NSString *eventId = [dict objectForKey:@"eventId"];
                                        model.eventId = eventId.integerValue;
                                        model.content = [dict objectForKey:@"content"];
                                        model.createTime = [[dict objectForKey:@"createTime"] integerValue];
                                        [array addObject:model];
                                    }
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        model.commentCount = array.count;
                                        if (conformToCondition) {
                                            [self.dataArray addObject:model];
                                            [self reloadData];
                                        }
                                    });
                                }
                            }];
                        } failurRequest:^(NSError *error) {
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

- (void)getOurSeverData:(NSString *)nick dateTime:(NSString *)dateTime {
    NSString *eventId = [NSString stringWithFormat:@"%@%@",nick,dateTime];
    NSMutableArray *__block array = [NSMutableArray array];
    AVQuery *query = [AVQuery queryWithClassName:@"eventCount"];
    [query whereKey:@"eventId" equalTo:eventId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count != 0) {
            for (AVObject *object in objects) {
                NSDictionary *dict = [object dictionaryForObject];
                YChatMessageModel *model = [YChatMessageModel new];
                model.isOurData = YES;
                model.user = [YActionUserModel new];
                model.user.nick = [dict objectForKey:@"user"];
                NSString *replayUserName = [dict objectForKey:@"replayUser"];
                if (![replayUserName isEqualToString:nick]) {
                    model.replyUser = [YActionUserModel new];
                    model.replyUser.nick = replayUserName;
                }
                NSString *eventId = [dict objectForKey:@"eventId"];
                model.eventId = eventId.integerValue;
                model.content = [dict objectForKey:@"content"];
                model.createTime = [[dict objectForKey:@"createTime"] integerValue];
                [array addObject:model];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                array.count;
            });
        }
    }];
}


@end
