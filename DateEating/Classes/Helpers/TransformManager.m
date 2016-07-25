//
//  TransformManager.m
//  蠢熊
//
//  Created by lanou3g on 16/4/14.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import "TransformManager.h"

@implementation TransformManager

static TransformManager *manager = nil;
+ (instancetype)shareTransformManager{
    
    if (!manager) {
        manager = [TransformManager new];
    }
    return manager;
}
+ (NSString *)UIImageToBase64Str: (UIImage *)image{
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
    
}
+ (UIImage *)Base64StrToImage: (NSString *)encodeImageString{
    
    NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:encodeImageString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    return decodedImage;
}


@end
