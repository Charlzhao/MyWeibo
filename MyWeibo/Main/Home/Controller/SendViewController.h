//
//  SendViewController.h
//  MyWeibo
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface SendViewController : BaseViewController<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    UILabel *_locLabel;
}

@end
