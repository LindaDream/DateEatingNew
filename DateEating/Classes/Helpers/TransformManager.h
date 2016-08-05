//
//  TransformManager.h
//  蠢熊
//
//  Created by user on 16/4/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TransformManager : NSObject

+ (instancetype)shareTransformManager;
+ (NSString *)UIImageToBase64Str: (UIImage *)image;
+ (UIImage *)Base64StrToImage: (NSString *)string;

@end
