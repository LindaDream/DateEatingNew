//
//  YFunnyModel.m
//  DateEating
//
//  Created by lanou3g on 16/7/19.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YFunnyModel.h"

@implementation YFunnyModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

    
    
}



+ (void)parsesFunnyWithsuccessRequest:(successRequest)success failurRequest:(failureRequest)failure{
    
    NSMutableArray *mArr = [NSMutableArray array];
    
    [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"select * from funnyObject"] callback:^(AVCloudQueryResult *result, NSError *error) {
        if (result != nil) {
            for (AVObject *obj in result.results) {
                
                NSDictionary *dic = [obj dictionaryForObject];
                YFunnyModel *funny = [YFunnyModel new];
                funny.imgArr = [NSMutableArray array];
                [funny setValuesForKeysWithDictionary:dic];

                if (funny.image0 != nil) {
                    [funny.imgArr addObject:funny.image0];
                }
                if (funny.image1 != nil) {
                    [funny.imgArr addObject:funny.image1];
                }
                if (funny.image2 != nil) {
                    [funny.imgArr addObject:funny.image2];
                }
                if (funny.image3 != nil) {
                    [funny.imgArr addObject:funny.image3];
                }
                if (funny.image4 != nil) {
                    [funny.imgArr addObject:funny.image4];
                }
                if (funny.image5 != nil) {
                    [funny.imgArr addObject:funny.image5];
                }
                if (funny.image6 != nil) {
                    [funny.imgArr addObject:funny.image6];
                }
                if (funny.image7 != nil) {
                    [funny.imgArr addObject:funny.image7];
                }
                if (funny.image8 != nil) {
                    [funny.imgArr addObject:funny.image8];
                }

                [mArr addObject:funny];
            }
            success(mArr);
        }else if(error != nil){
        
            failure(error);
            
        }else{
        
            NSLog(@"没有数据");
            
        }
       
        
    }];
    
}



- (NSString *)description
{
    return [NSString stringWithFormat:@"image0 = %@, image1 = %@, image2 = %@, image3 = %@, image4 = %@, image5 = %@, image6 = %@, image7 = %@, image8 = %@, ", self.image0,self.image1, self.image2,self.image3,self.image4,self.image5,self.image6,self.image7,self.image8];
}



@end
