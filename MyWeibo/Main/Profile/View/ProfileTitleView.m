//
//  ProfileTitleView.m
//  MyWeibo
//
//  Created by mac on 15/10/14.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ProfileTitleView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
@implementation ProfileTitleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    _userImage.layer.borderColor = [UIColor purpleColor].CGColor;
//    // 设置边框宽度
//    _userImage.layer.borderWidth = 1;
//    // 视图的圆角
//    _userImage.layer.cornerRadius = _userImage.bounds.size.width / 2;
//    _userImage.layer.masksToBounds = YES;
    
}

- (void)setLayout:(WeiboViewFrameLayout *)layout
{
    if(_layout != layout)
    {
        _layout = layout;
        [self setNeedsLayout];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    WeiboModel *_model = _layout.model;
    NSString *imageString = _model.userModel.profile_image_url;
    NSURL *url = [NSURL URLWithString:imageString];
    [_userImage sd_setImageWithURL:url];
    //    _userImage.image = [UIImage imageNamed:imageString];
    
    if ([_model.userModel.gender isEqualToString:@"m"])
    {
        _sexLabel.text = @"男";
    }
    else if ([_model.userModel.gender isEqualToString:@"f"])
    {
        _sexLabel.text = @"女";
    }
    else if ([_model.userModel.gender isEqualToString:@"n"])
    {
        _sexLabel.text = @"未知";
    }
    
    _userNameLabel.text = _model.userModel.screen_name;
    
    _addressLabel.text = _model.userModel.location;
   // _briefLabel.text = [NSString stri ngWithFormat:@"简介:%@",_model.userModel.description];
}

- (IBAction)attention:(UIButton *)sender {
}

- (IBAction)fansAction:(UIButton *)sender {
}
- (IBAction)moreAction:(UIButton *)sender {
}

- (IBAction)dataAction:(UIButton *)sender {
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
