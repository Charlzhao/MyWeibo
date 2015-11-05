//
//  ThemeManger.h
//  MyWeibo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kThemeNameDidChangeNotification @"kThemeNameDidChangeNotification"
#define kThemeName @"kThemeName"
@interface ThemeManger : NSObject

@property (nonatomic, copy)NSString *themeName;  //主题名

+ (ThemeManger *)shareInstance;

- (UIImage *)getThemeImage:(NSString *)imageName;

- (UIColor *)getThemeColor:(NSString *)colorName;

@end
