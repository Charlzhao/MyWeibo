//
//  NearByViewController.m
//  MyWeibo
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "NearByViewController.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"
#import "DataService.h"
#import "WeiboModel.h"
#import "DetailViewController.h"
@interface NearByViewController ()

@end

@implementation NearByViewController
{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createView];
//    CLLocationCoordinate2D coordinate = {30.2042,120.2019};
//    
//    WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
//    annotation.coordinate = coordinate;
//    annotation.title = @"汇文教育";
//    annotation.subtitle = @"xs27";
//    
//    [_mapView addAnnotation:annotation];
    
}

- (void)_createView
{
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    
    _mapView.showsUserLocation = YES;
    
    _mapView.mapType = MKMapTypeStandard;
    //_mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.delegate = self;
    [self.view addSubview: _mapView];
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - mapView代理

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"选中");
    if (![view.annotation isKindOfClass:[WeiboAnnotation class]])
    {
        return;
    }
    WeiboAnnotation *weiboAnnotation = (WeiboAnnotation *)view.annotation;
    WeiboModel *weiboModel = weiboAnnotation.model;
    
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.weiboModel = weiboModel;
    
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 *  mapView位置更新后被调用
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{


    CLLocation *location = [userLocation location];
    CLLocationCoordinate2D    coordinate = [location coordinate];

    NSLog(@"纬度  %lf,精度 %lf",coordinate.latitude,coordinate.longitude);
    
    CLLocationCoordinate2D ceter = coordinate;
    
    MKCoordinateSpan span = {0.5,0.5};
    MKCoordinateRegion region = {ceter,span};
    
    mapView.region = region;
    
    //网络获取附近微博
    NSString *lon = [NSString stringWithFormat:@"%f",coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
    [self _loadNearByData:lon lat:lat];
}
/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
    if (pin == nil)
    {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
        
        pin.pinColor = MKPinAnnotationColorGreen;
        
        pin.canShowCallout = YES;
        pin.animatesDrop = YES;

    }
    
    return pin;
}
*/

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    if ([annotation isKindOfClass:[WeiboAnnotation class]])
    {
        WeiboAnnotationView *view = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
        if (view == nil)
        {
            view = [[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
        }
        
        view.annotation = annotation;
        [view setNeedsLayout];
        
        return view;
    }
    
    
    return nil;
}


//获取附近微博
- (void)_loadNearByData:(NSString *)lon lat:(NSString *)lat{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:lon forKey:@"long"];
    [params setObject:lat forKey:@"lat"];
    
    [DataService requestAFUrl:nearby_timeline httpMethod:@"GET" params:params data:nil block:^(id result) {
        
        NSArray *statuses = [result objectForKey:@"statuses"];
        NSMutableArray *annotationArray = [[ NSMutableArray alloc] initWithCapacity:statuses.count];
        for (NSDictionary *dic in statuses)
        {
            WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic];
            WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
            annotation.model = model;
            
            [annotationArray addObject:annotation];
        }
        [_mapView addAnnotations:annotationArray];
    }];
}

@end
