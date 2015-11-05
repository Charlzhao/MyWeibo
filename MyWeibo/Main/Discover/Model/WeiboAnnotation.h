//
//  WeiboAnnotation.h
//  MyWeibo
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WeiboModel.h"
@interface WeiboAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign)CLLocationCoordinate2D coordinate;

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *subtitle;

//微博数据
@property (nonatomic,strong) WeiboModel *model;
@end
