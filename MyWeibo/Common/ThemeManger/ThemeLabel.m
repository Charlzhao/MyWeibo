//
//  ThemeLabel.m
//  MyWeibo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManger.h"
@implementation ThemeLabel

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange:) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange:) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}

- (void)themeChange:(NSNotification *)notification
{
    [self loadColor];
}

- (void)setColorName:(NSString *)colorName
{
    if (![_colorName isEqualToString:colorName])
    {
        _colorName = [colorName copy];
        [self loadColor];
    }
}

- (void)loadColor
{
    ThemeManger *manger = [ThemeManger shareInstance];
    self.textColor = [manger getThemeColor:self.colorName];
}

@end
