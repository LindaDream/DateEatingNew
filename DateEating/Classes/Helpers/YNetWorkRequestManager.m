//
//  YNetWorkRequestManager.m
//  DateEating
//
//  Created by lanou3g on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YNetWorkRequestManager.h"

@implementation YNetWorkRequestManager

+ (void)getRequestWithUrl:(NSString *)url successRequest:(successRequest)success failurRequest:(failureRequest)failure{

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"------------%@",data);
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            success(dict);
        }else{
            failure(error);
        }
        
        
    }];
    [dataTask resume];
}

@end
