//
//  BaseViewController.h
//  MyWeibo
//
//  Created by mac on 15/10/7.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperation.h"
@interface BaseViewController : UIViewController

- (void)setNavTtem;


//实现加载的效果：三方
- (void)showHud:(NSString *)title;
- (void)hideHud;
- (void)comleteHud:(NSString *)title;
////系统
//- (void)showLoading:(BOOL)show;

- (void)showStatus:(NSString *)title
              show:(BOOL)show
         operation:(AFHTTPRequestOperation *)operation;

@end
