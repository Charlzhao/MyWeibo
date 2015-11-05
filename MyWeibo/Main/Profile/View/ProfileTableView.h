//
//  ProfileTableView.h
//  MyWeibo
//
//  Created by mac on 15/10/14.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WeiboModel.h"
@interface ProfileTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)NSArray *weiboArray;

@end
