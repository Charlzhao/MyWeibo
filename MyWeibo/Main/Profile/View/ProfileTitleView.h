//
//  ProfileTitleView.h
//  MyWeibo
//
//  Created by mac on 15/10/14.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeLabel.h"
#import "WeiboViewFrameLayout.h"
@interface ProfileTitleView : UIView

@property (weak, nonatomic) IBOutlet ThemeLabel *userNameLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *sexLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *addressLabel;

@property (weak, nonatomic) IBOutlet ThemeLabel *briefLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (nonatomic, copy)WeiboViewFrameLayout *layout;

@end
