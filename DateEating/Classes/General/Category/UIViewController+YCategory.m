//
//  UIViewController+YCategory.m
//  DateEating
//
//  Created by user on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "UIViewController+YCategory.h"
#import "YPublishDateViewController.h"
#import "YPublishPartyViewController.h"
#import "YTabBar.h"
#import "AppDelegate.h"
@implementation UIViewController (YCategory)

-(void)changeToNight{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.alpha = 0.6;
}

-(void)changeToDay{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.alpha = 1.0;
}

-(void)addDateBtnAndPartyBtn{
    UIButton *dateBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    dateBtn.frame = CGRectMake(207, 696.5, 100, 100);
    [dateBtn setBackgroundImage:[UIImage imageNamed:@"event_single"] forState:(UIControlStateNormal)];
    [dateBtn addTarget:self action:@selector(addDate:) forControlEvents:(UIControlEventTouchUpInside)];
    dateBtn.tag = 101;
    [self.view addSubview:dateBtn];
    
    UIButton *partyBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    partyBtn.frame = CGRectMake(207, 696.5, 100, 100);
    [partyBtn setBackgroundImage:[UIImage imageNamed:@"event_multi"] forState:(UIControlStateNormal)];
    [partyBtn addTarget:self action:@selector(addParty:) forControlEvents:(UIControlEventTouchUpInside)];
    partyBtn.tag = 102;
    [self.view addSubview:partyBtn];
    [UIView animateKeyframesWithDuration:1 delay:0 options:(UIViewKeyframeAnimationOptionCalculationModeLinear) animations:^{
        // 第一帧
        dateBtn.center = CGPointMake(103, 500);
        partyBtn.center = CGPointMake(311, 500);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)addDate:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeIsClickedValue" object:nil userInfo:@{@"isClicked":[NSNumber numberWithBool:1]}];
    YPublishDateViewController *dateVC = [YPublishDateViewController new];
    UIButton *dateBtn = (UIButton *)[self.view viewWithTag:101];
    UIButton *partyBtn = (UIButton *)[self.view viewWithTag:102];
    [dateBtn removeFromSuperview];
    [partyBtn removeFromSuperview];
    UIButton *addBtn = [self.tabBarController.tabBar.subviews objectAtIndex:1];
    [UIView animateWithDuration:0.5 animations:^{
        addBtn.transform = CGAffineTransformRotate(addBtn.transform, -M_PI_4);
        
    }];
    [[self.view subviews] lastObject].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:2].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:3].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:4].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:5].userInteractionEnabled = YES;
    [self.navigationController pushViewController:dateVC animated:YES];
}
- (void)addParty:(UIButton *)btn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeIsClickedValue" object:nil userInfo:@{@"isClicked":[NSNumber numberWithBool:1]}];
    YPublishPartyViewController *partyVC = [YPublishPartyViewController new];
    UIButton *dateBtn = (UIButton *)[self.view viewWithTag:101];
    UIButton *partyBtn = (UIButton *)[self.view viewWithTag:102];
    [dateBtn removeFromSuperview];
    [partyBtn removeFromSuperview];
    UIButton *addBtn = [self.tabBarController.tabBar.subviews objectAtIndex:1];
    [UIView animateWithDuration:0.5 animations:^{
        addBtn.transform = CGAffineTransformRotate(addBtn.transform, -M_PI_4);
        
    }];
    [[self.view subviews] lastObject].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:2].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:3].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:4].userInteractionEnabled = YES;
    [self.tabBarController.tabBar.subviews objectAtIndex:5].userInteractionEnabled = YES;
    [self.navigationController pushViewController:partyVC animated:YES];
}
-(void)removeDateBtnAndPartyBtn{
    UIButton *dateBtn = (UIButton *)[self.view viewWithTag:101];
    UIButton *partyBtn = (UIButton *)[self.view viewWithTag:102];
    [dateBtn removeFromSuperview];
    [partyBtn removeFromSuperview];
}
#pragma mark--高度自适应--
-(CGFloat)textHeightForLabel:(UILabel *)label{
    CGRect rect = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, 500) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    return rect.size.height;
}
#pragma mark--计算距离--
-(CLLocationDegrees)userLat{
    return 0;
}
-(CLLocationDegrees)userLog{
    return 0;
}
-(CGFloat)distanceToTarget:(CLLocationDegrees)lat log:(CLLocationDegrees)log{
    CGFloat distance = 0;
    // 获取手机当前位置
    //初始化BMKLocationService
    BMKLocationService *locService = [[BMKLocationService alloc]init];
    locService.delegate = self;
    //启动LocationService
    [locService startUserLocationService];
    // 计算距离
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(self.userLat,self.userLog));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(lat,log));
    distance = BMKMetersBetweenMapPoints(point1,point2);
    distance = distance / 1000000;
    return distance;
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.userLat = userLocation.location.coordinate.latitude;
    self.userLog = userLocation.location.coordinate.longitude;
}

@end
