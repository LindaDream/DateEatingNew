//
//  YFunnyModel.h
//  DateEating
//
//  Created by lanou3g on 16/7/19.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFunnyModel : NSObject

@property (strong,nonatomic) NSString *publishName;    // 发布人的用户名
@property (strong,nonatomic) NSString *publishTime;    // 发布时间
@property (strong,nonatomic) NSString *publishContent; // 发布的文字内容
@property (strong,nonatomic) NSMutableArray *imgArr;   // 存放图片的数组

// 以下是九张图片
//@property (strong,nonatomic) UIImage *image0;
//@property (strong,nonatomic) UIImage *image1;
//@property (strong,nonatomic) UIImage *image2;
//@property (strong,nonatomic) UIImage *image3;
//@property (strong,nonatomic) UIImage *image4;
//@property (strong,nonatomic) UIImage *image5;
//@property (strong,nonatomic) UIImage *image6;
//@property (strong,nonatomic) UIImage *image7;
//@property (strong,nonatomic) UIImage *image8;

// 以下是九张图片对应的AVFileUrl
@property (strong,nonatomic) NSString *image0;
@property (strong,nonatomic) NSString *image1;
@property (strong,nonatomic) NSString *image2;
@property (strong,nonatomic) NSString *image3;
@property (strong,nonatomic) NSString *image4;
@property (strong,nonatomic) NSString *image5;
@property (strong,nonatomic) NSString *image6;
@property (strong,nonatomic) NSString *image7;
@property (strong,nonatomic) NSString *image8;


// 请求Model对象
+ (void)parsesFunnyWithsuccessRequest:(successRequest)success failurRequest:(failureRequest)failure;

// 请求图片
//+ (void)imgWithFile:(AVFile *)file successRequest:(successRequest)success failurRequest:(failureRequest)failure;

@end
