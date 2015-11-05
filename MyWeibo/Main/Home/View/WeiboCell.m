//
//  WeiboCell.m
//  MyWeibo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
@implementation WeiboCell

- (void)awakeFromNib
{
    [self _createSubView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)_createSubView
{
    _weiboView = [[WeiboView alloc] init];
    [self.contentView addSubview:_weiboView];
}

- (void)setLayout:(WeiboViewFrameLayout *)layout
{
    if (_layout != layout)
    {
        _layout = layout;
        
        _weiboView.layout = layout;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    WeiboModel *_model = _layout.model;
    //01 头像
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.userModel.profile_image_url]];
    //02 昵称
    _nickNameLabel.text = _model.userModel.screen_name;
    //03 评论
    NSString *commentCount = [_model.commentsCount stringValue];
    _commentLabel.text = [NSString stringWithFormat:@"评论:%@",commentCount];
    
    //04 转发
    NSString *repostCount = [_model.repostsCount stringValue];
    _rePostLabel.text = [NSString stringWithFormat:@"转发:%@",repostCount];
    
    //05 来源
    _srLabel.text = _model.source;
    
    _weiboView.frame = _layout.frame;
}

@end
