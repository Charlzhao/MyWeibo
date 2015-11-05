//
//  ThemeManger.m
//  MyWeibo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeManger.h"

@implementation ThemeManger
{
    NSDictionary *_themeConfig;
    NSDictionary *_themeColorName;
}
+ (ThemeManger *)shareInstance
{
    static ThemeManger *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        //读取本地保存数据
        _themeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
        if (_themeName.length == 0)
        {
            _themeName = @"Cat";
        }
        
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        _themeConfig = [NSDictionary dictionaryWithContentsOfFile:configPath];
        
        [self _loadColor];
    }
    return self;
}
- (void)setThemeName:(NSString *)themeName
{
    if (![_themeName isEqualToString:themeName])
    {
        _themeName = [themeName copy];
        
        //将数据存储到plist文件中保存
        [[NSUserDefaults standardUserDefaults] setObject:_themeName forKey:kThemeName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self _loadColor];
       
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeNameDidChangeNotification object:nil];
    }
}

- (UIImage *)getThemeImage:(NSString *)imageName
{
    NSString *themePath = [self themePath];
    
    NSString *filePath = [themePath stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    return image;
}

- (UIColor *)getThemeColor:(NSString *)colorName
{
    if (colorName.length == 0)
    {
        return nil;
    }
    NSDictionary *rgbDictionary = [_themeColorName objectForKey:colorName];
    CGFloat red = [rgbDictionary[@"R"] floatValue];
    CGFloat green = [rgbDictionary[@"G"] floatValue];
    CGFloat blue = [rgbDictionary[@"B"] floatValue];
    
    CGFloat alpha = 1;
    
    if (rgbDictionary[@"alpha"] != nil)
    {
        alpha = [rgbDictionary[@"alpha"] floatValue];
    }
    UIColor *color = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
    return color;
}
//读取颜色配置
- (void)_loadColor
{
    NSString *themePath = [self themePath];
    NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
    _themeColorName = [NSDictionary dictionaryWithContentsOfFile:filePath];
}
//主题包路径
- (NSString *)themePath
{
    NSString *resPath = [[NSBundle mainBundle] resourcePath];
    NSString *pathSufix = [_themeConfig objectForKey:self.themeName];
    
    NSString *path = [resPath stringByAppendingPathComponent:pathSufix];
    return path;
}
@end
