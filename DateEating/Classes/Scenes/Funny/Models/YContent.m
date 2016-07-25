//
//  YContent.m
//  DateEating
//
//  Created by lanou3g on 16/7/21.
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



@end
