//
//  YContent.m
//  DateEating
//
//  Created by user on 16/7/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YContent.h"

@implementation YContent


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

    
    
}



+ (void)parsesContentWithOwnerId:(NSString *)ownerId SuccessRequest:(successRequest)success failurRequest:(failureRequest)failure{
    
    NSMutableArray *mArr = [NSMutableArray array];
    [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"select * from ContentObject where ownerId = '%@'",ownerId] callback:^(AVCloudQueryResult *result, NSError *error) {
        if (result != nil) {
            for (AVObject *obj in result.results) {
                
                NSDictionary *dic = [obj dictionaryForObject];
                YContent *content = [YContent new];
                [content setValuesForKeysWithDictionary:dic];
                
                [mArr addObject:content];
                
            }
            success(mArr);
        }else if(error != nil){
            
            failure(error);
            
        }else{
            
            NSLog(@"没有数据");
            
        }
    }];
    
}

// 获取头像
+ (void)getContentAvatarWithUserName:(NSString *)userName SuccessRequest:(successRequest)success failurRequest:(failureRequest)failure{
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error != nil) {
            NSLog(@"%ld",error.code);
        }else if (objects.count != 0){
            AVObject *user = objects[0];
            AVFile *file = [user objectForKey:@"avatar"];
            success(file.url);
        }else{
            success(@"该用户不存在");
        }
        
    }];
    
}

// 通过leanclude账号获取头像
+ (void)getContentAvatarWithUserName:(NSString *)userName key:(NSString *)key SuccessRequest:(successRequest)success failurRequest:(failureRequest)failure{
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query whereKey:key equalTo:userName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error != nil) {
            NSLog(@"%ld",error.code);
        }else if (objects.count != 0){
            AVObject *user = objects[0];
            AVFile *file = [user objectForKey:@"avatar"];
            success(file.url);
        }else{
            success(@"该用户不存在");
        }
        
    }];
    
}




// 通过环信号获取头像
+ (void)getContentAvatarWithHxuserName:(NSString *)hxuserName SuccessRequest:(successRequest)success failurRequest:(failureRequest)failure{
    
    [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"select * from _User where hxUserName = '%@'",hxuserName] callback:^(AVCloudQueryResult *result, NSError *error) {
        if (result != nil) {
            AVObject *user = result.results.firstObject;
            NSString *userName = [user objectForKey:@"username"];
            [self getContentAvatarWithUserName:userName key:@"username" SuccessRequest:^(id dict) {
                success(dict);
            } failurRequest:^(NSError *error) {
                failure(error);
            }];
        }else if(error != nil){
            
            failure(error);
            
        }else{
            
            NSLog(@"没有数据");
            
        }
        
    }];
        
        
}




@end
