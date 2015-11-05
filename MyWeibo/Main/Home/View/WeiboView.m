//
//  WeiboView.m
//  MyWeibo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboView.h"
#import "UIImageView+WebCache.h"
#import "ThemeManger.h"
@implementation WeiboView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self _createSubView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self _createSubView];
    }
    return self;
}
- (void)_createSubView
{
    _textLabel = [[WXLabel alloc] init];
   // _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.linespace = 5;
    _textLabel.wxLabelDelegate = self;
    
    _sourceLabel = [[WXLabel alloc] init];
   // _sourceLabel.font = [UIFont systemFontOfSize:14];
    _sourceLabel.linespace = 5;
    _sourceLabel.wxLabelDelegate = self;
    
    _imgView = [[ZoomImageView alloc] init];
    _bgImageView = [[ThemeImageView alloc] init];
    _bgImageView.leftCap = 30;
    _bgImageView.topCap = 30;
    
    
    [self addSubview:_bgImageView];
    [self addSubview:_textLabel];
    [self addSubview:_sourceLabel];
    [self addSubview:_imgView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDicChange:) name:kThemeNameDidChangeNotification object:nil];
    
}

#pragma mark 主题切换通知
- (void)themeDicChange:(NSNotification *)notification{
    //Timeline_Content_color
    
    _textLabel.textColor = [[ThemeManger shareInstance] getThemeColor:@"Timeline_Content_color"];
    
    _sourceLabel.textColor = [[ThemeManger shareInstance] getThemeColor:@"Timeline_Content_color"];
    
}

- (void)setLayout:(WeiboViewFrameLayout *)layout
{
    if (_layout != layout)
    {
        _layout = layout;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _textLabel.font =   [UIFont systemFontOfSize: FontSize_Weibo(_layout.isDetail)] ;
    _sourceLabel.font =  [UIFont systemFontOfSize: FontSize_ReWeibo(_layout.isDetail)] ;
    
    
    WeiboModel *model = _layout.model;
    _textLabel.frame = _layout.textFrame;
    _textLabel.text = model.text;
    
    if (model.reWeiboModel != nil)  // 有转发情况
    {
        _bgImageView.hidden = NO;
        _sourceLabel.hidden = NO;
        
        //被转发的微博
        _sourceLabel.frame = _layout.srTextFrame;
        _sourceLabel.text = model.reWeiboModel.text;
        
        _bgImageView.frame = _layout.bgImageFrame;
        _bgImageView.imageName = @"timeline_rt_border_9.png";
        
        NSString *imageStr = model.reWeiboModel.thumbnailImage;
        if (imageStr == nil)
        {
            _imgView.hidden = YES;
        }else
        {
            _imgView.fullImageUrlString = model.reWeiboModel.originalImage;
            _imgView.hidden = NO;
            _imgView.frame = _layout.imgFrame;
            [_imgView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
        }
    }
    else  //无转发
    {
        _bgImageView.hidden = YES;
        _sourceLabel.hidden = YES;
        
        NSString *imageStr = model.thumbnailImage;
        if (imageStr == nil)
        {
            _imgView.hidden = YES;
        }
        else
        {
            _imgView.fullImageUrlString = model.originalImage;
            _imgView.hidden = NO;
            _imgView.frame = _layout.imgFrame;
            [_imgView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
        }
    }
    if (_imgView.hidden == NO)
    {
        _imgView.iconView.frame = CGRectMake(_imgView.width - 24, _imgView.height -24, 24, 24);
        NSString *extersion;
        
        if (model.reWeiboModel != nil)
        {
            extersion = [model.reWeiboModel.thumbnailImage pathExtension];
        }
        else
        {
            extersion = [model.thumbnailImage pathExtension];
        }
        if ([extersion isEqualToString:@"gif"])
        {
            _imgView.isGif = YES;
            _imgView.iconView.hidden = NO;
        }
        else
        {
            _imgView.isGif = NO;
            _imgView.iconView.hidden = YES;
        }
    }
    
    
}


#pragma mark - wxlabel 代理

- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;
}

- (void)toucheBenginWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
    NSLog(@"点击");
}


//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
    return  [[ThemeManger shareInstance] getThemeColor:@"Link_color"];
}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel{
    
    return  [UIColor redColor];
}

@end
