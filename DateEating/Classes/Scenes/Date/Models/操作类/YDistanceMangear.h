//
//  YDistanceMangear.h
//  DateEating
//
//  Created by user on 16/7/22.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDistanceMangear : NSObject

singleton_interface(YDistanceMangear);

- (CGFloat)getDistanceByUserLocation:(BMKUserLocation *)userLocation Latitude:(CGFloat)latitude longitude:(CGFloat)longitude;
@end
