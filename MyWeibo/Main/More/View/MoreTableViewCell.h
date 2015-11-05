//
//  MoreTableViewCell.h
//  MyWeibo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeImageView.h"
#import "ThemeLabel.h"
@interface MoreTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet ThemeImageView *themeImageView;

@property (weak, nonatomic) IBOutlet ThemeLabel *themeTextLabel;


@property (weak, nonatomic) IBOutlet ThemeLabel *themeDetailLabel;



@end
