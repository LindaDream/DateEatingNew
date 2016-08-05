//
//  YDistanceMangear.m
//  DateEating
//
//  Created by user on 16/7/22.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YDistanceMangear.h"
#import  <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
@interface YDistanceMangear ()<BMKLocationServiceDelegate>

@property (strong, nonatomic) BMKLocationService *locationService;

@end

@implementation YDistanceMangear

singleton_implementaton(YDistanceMangear)

// 根据给定的坐标获取距离
- (CGFloat)getDistanceByUserLocation:(BMKUserLocation *)userLocation Latitude:(CGFloat)latitude longitude:(CGFloat)longitude {
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(40.036149,116.35009));
    //BMKMapPoint point1 = BMKMapPointForCoordinate(userLocation.location.coordinate);
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longitude));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    return distance;
}



@end
