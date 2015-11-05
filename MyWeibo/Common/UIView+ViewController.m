//
//  UIView+ViewController.m
//  MyWeibo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)viewController
{
    //利用响应者链找到controller
    UIResponder *nextResponder = self.nextResponder;
    while (nextResponder != nil)
    {
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
        nextResponder = nextResponder.nextResponder;
    }
    
    return nil;
}


@end
