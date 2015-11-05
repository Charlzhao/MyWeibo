//
//  MoreViewController.m
//  MyWeibo
//
//  Created by mac on 15/10/7.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreTableViewCell.h"
#import "ThemeManger.h"
#import "MoreTableViewController.h"
#import "AppDelegate.h"
@interface MoreViewController ()<UIAlertViewDelegate>

@end

@implementation MoreViewController
{
    BOOL _islogIn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.backgroundColor = [UIColor clearColor];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [_tableView reloadData];
}

#pragma mark - TableViewDelegat
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreTableViewCell" owner:nil options:nil] lastObject];
    }
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.themeImageView.imageName = @"more_icon_theme.png";
            cell.themeTextLabel.text = @"主题选择";
            cell.themeDetailLabel.text = [ThemeManger shareInstance].themeName;
        }
        else if (indexPath.row == 1)
        {
            cell.themeImageView.imageName = @"more_icon_account.png";
            cell.themeTextLabel.text = @"账户管理";
        }
    }
    else if (indexPath.section == 1)
    {
        cell.themeImageView.imageName = @"more_icon_feedback.png";
        cell.themeTextLabel.text = @"意见反馈";
    }
    else if (indexPath.section == 2)
    {
        cell.themeTextLabel.text = @"登陆账号";
        cell.themeTextLabel.textAlignment = NSTextAlignmentCenter;
        cell.themeTextLabel.center = cell.contentView.center;
        
        if (_islogIn)
        {
            cell.themeTextLabel.text = @"登陆账号";
        }
        else
        {
            cell.themeTextLabel.text = @"登出账号";
        }
    }
    
    return cell;
}

//单元格选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [self.navigationController pushViewController:[[MoreTableViewController alloc] init] animated:YES];
    }
    else if (indexPath.section == 2)
    {
        if (!_islogIn)
        {
//            cell.themeTextLabel.text = @"登陆账号";
            AppDelegate *appDelegat = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if ([appDelegat.sinaweibo isLoggedIn])
            {
                
            }
            else
            {
                [appDelegat.sinaweibo logIn];
                _islogIn = YES;
            }
            
        }
        else
        {
//            cell.themeTextLabel.text = @"登出账号";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否退出登录？"message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alertView show];
        }
    }
    
    
}

#pragma mark - alertView delegat

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        AppDelegate *appDelegat = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegat.sinaweibo logOut];
        _islogIn = NO;
    }
    
    
}






@end
