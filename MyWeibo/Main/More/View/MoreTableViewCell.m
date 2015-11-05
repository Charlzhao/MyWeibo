//
//  MoreTableViewCell.m
//  MyWeibo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MoreTableViewCell.h"
#import "ThemeManger.h"
@implementation MoreTableViewCell
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}

- (void)themeDidChange
{
    [self loadColor];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:kThemeNameDidChangeNotification object:nil];
    [self loadColor];
    
}

- (void)loadColor
{
    _themeDetailLabel.colorName = @"More_Item_Text_color";
    _themeTextLabel.colorName = @"More_Item_Text_color";

    self.backgroundColor = [[ThemeManger shareInstance] getThemeColor:@"More_Item_color"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
