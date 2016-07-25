//
//  YMapViewController.m
//  DateEating
//
//  Created by user on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YMapViewController.h"

@interface YMapViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>
@property(strong,nonatomic)BMKMapView *mapView;
@property(strong,nonatomic)BMKGeoCodeSearch *searcher;
@end

@implementation YMapViewController

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    self.view = self.mapView;
    // 设置缩放比例
    self.mapView.zoomLevel = 15;
    // 初始化检索对象
    self.searcher = [[BMKGeoCodeSearch alloc] init];
    self.searcher.delegate = self;
    BMKGeoCodeSearchOption *option = [[BMKGeoCodeSearchOption alloc] init];
    option.city = self.model.name;
    option.address = self.model.address;
    BOOL flag = [self.searcher geoCode:option];
    if (flag) {
        NSLog(@"检索发送成功");
    }else{
        NSLog(@"检索发送失败");
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
-(void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    // 大头针
    BMKPointAnnotation *annotation = [BMKPointAnnotation new];
    // 设置经纬度
    annotation.coordinate = result.location;
    annotation.title = self.model.name;
    annotation.subtitle = result.address;
    [self.mapView addAnnotation:annotation];
    // 设置当前地点为中心点
    self.mapView.centerCoordinate = result.location;
}
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    // 大头针视图的标识符
    NSString *annotationViewID = @"annotationID";
    // 根据标识符找到一个可以复用的大头针
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewID];
        ((BMKPinAnnotationView *)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置动画效果
        ((BMKPinAnnotationView *)annotationView).animatesDrop = YES;
    }
    
    annotationView.annotation = annotation;
    // 设置点击大头针弹出提示信息
    annotationView.canShowCallout = YES;
    return annotationView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
