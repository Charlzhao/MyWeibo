//
//  ThemeButton.m
//  MyWeibo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManger.h"
@implementation ThemeButton

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}

- (void)setNormalImageName:(NSString *)normalImageName
{
    if (![_normalImageName isEqualToString:normalImageName])
    {
        _normalImageName = [normalImageName copy];
        [self loadImage];
    }
}

- (void)setHighlightedImageName:(NSString *)highlightedImageName
{
    if (![_highlightedImageName isEqualToString:highlightedImageName])
    {
        _highlightedImageName = [highlightedImageName copy];
        [self loadImage];
    }
}

- (void)themeDidChange:(NSNotification *)notification
{
    [self loadImage];
}

- (void)setBackColorImageName:(NSString *)backColorImageName
{
    if (![_backColorImageName isEqualToString:backColorImageName])
    {
        _backColorImageName = [_backColorImageName copy];
        [self loadImage];
    }
}

- (void)loadImage
{
    ThemeManger *manger = [ThemeManger shareInstance];
    UIImage *normalImage = [manger getThemeImage:self.normalImageName];
    UIImage *highlightedImage = [manger getThemeImage:self.highlightedImageName];
    UIImage *backColorImage = [manger getThemeImage:self.backColorImageName];
    if (normalImage != nil)
    {
        [self setImage:normalImage forState:UIControlStateNormal];
    }
    if (highlightedImage != nil)
    {
        [self setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    if (backColorImage != nil)
    {
        [self setBackgroundImage:backColorImage forState:UIControlStateNormal];
    }
    
}
@end
