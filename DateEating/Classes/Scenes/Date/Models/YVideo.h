//
//  YVideo.h
//  DateEating
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YVideo : NSObject

@property (assign, nonatomic) NSInteger ID;
@property (strong, nonatomic) NSString *orientation;  // 定位
@property (strong, nonatomic) NSString *videoImgUrl;
@property (strong, nonatomic) NSString *videoSource;
@property (assign, nonatomic) NSInteger videoTime;
@property (strong, nonatomic) NSString *videoUrl;


@end
