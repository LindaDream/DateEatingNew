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
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
            success(dict);
        }else{
            failure(error);
        }
        
        
    }];
    [dataTask resume];
}


+ (void)postRequestWithPath:(NSString *)path successRequest:(successRequest)success failurRequest:(failureRequest)failure{
    
    NSArray *arr = [path componentsSeparatedByString:@"?"];
    NSURL *url = [NSURL URLWithString:arr[0]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSData *bodyData = [arr[1] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
