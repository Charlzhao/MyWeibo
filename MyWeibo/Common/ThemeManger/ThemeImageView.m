//
//  ThemeImageView.m
//  MyWeibo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManger.h"
@implementation ThemeImageView

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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}

- (void)setImageName:(NSString *)imageName
{
    if (![_imageName isEqualToString:imageName])
    {
        _imageName = [imageName copy];
        [self loadImage];
    }
    
}

- (void)themeDidChange:(NSNotification *)notification
{
    [self loadImage];
}

- (void)loadImage
{
    ThemeManger *manger = [ThemeManger shareInstance];
    
    UIImage *image = [manger getThemeImage:self.imageName];
    image =  [image stretchableImageWithLeftCapWidth:_leftCap topCapHeight:_topCap];
    if (image != nil)
    {
        self.image = image;
    }
}
@end
