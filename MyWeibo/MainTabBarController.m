//
//  MainTabBarController.m
//  MyWeibo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "ThemeImageView.h"
#import "ThemeButton.h"
#import "AppDelegate.h"
#import "ThemeLabel.h"
@interface MainTabBarController ()<SinaWeiboRequestDelegate>
{
    ThemeImageView *_selectImageView;
    
    ThemeImageView *_badgeImageView;
    ThemeLabel *_badgeLabel;
}
@end

@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _creatSubController]; //创建子视图控制器
    [self _creatTabBar];   //设置tabBar相关的属性
    
    [NSTimer scheduledTimerWithTimeInterval:100000 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
}

- (void)_creatSubController
{
    NSArray *names = @[@"Home", @"Message", @"Profile", @"Discover", @"More"];
    NSMutableArray *navArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < names.count; i++)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:names[i] bundle:nil];
        BaseNavigationController *nav = [storyBoard instantiateInitialViewController];
        [navArray addObject:nav];
    }
    self.viewControllers = navArray;
}

- (void)_creatTabBar
{
    //移除tabBarButton
    for (UIView *view in self.tabBar.subviews)
    {
        Class cls = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:cls])
        {
            [view removeFromSuperview];
        }
    }
    //背景图片
    ThemeImageView *bgImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    bgImageView.imageName = @"mask_navbar.png";
//    bgImageView.image = [UIImage imageNamed:@"Skins/cat/mask_navbar.png"];
    [self.tabBar addSubview:bgImageView];

    //选中图片
    _selectImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 5, 49)];
//    _selectImageView.image = [UIImage imageNamed:@"Skins/cat/home_bottom_tab_arrow.png"];
    _selectImageView.imageName = @"home_bottom_tab_arrow.png";
    [self.tabBar addSubview:_selectImageView];
    
    //每个button的宽度
    CGFloat itemWidth = kScreenWidth / 5;
    //button
    for (int i = 0; i < 5; i++)
    {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, 49)];
        button.tag = i;
        NSString *imageString = [NSString stringWithFormat:@"home_tab_icon_%i.png", i + 1];
//        [button setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
        button.normalImageName = imageString;
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
    }
    
    
}

- (void)selectAction:(UIButton *)button
{
    [UIView animateWithDuration:0.2 animations:^{
        _selectImageView.center = button.center;
    }];
    self.selectedIndex = button.tag;
    
}

- (void)timerAction:(NSTimer *)timer
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWibo = appDelegate.sinaweibo;
    
    [sinaWibo requestWithURL:unread_count params:nil httpMethod:@"GET" delegate:self];
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSNumber *status = [result objectForKey:@"status"];
    NSInteger count = [status integerValue];
    
    CGFloat buttonWidth = kScreenWidth / 5;
    
    if (_badgeImageView == nil)
    {
        _badgeImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(buttonWidth-32, 0, 32, 32)];
        _badgeImageView.imageName = @"number_notify_9.png";
        
        [self.tabBar addSubview:_badgeImageView];
        
        _badgeLabel = [[ThemeLabel alloc] initWithFrame:_badgeImageView.bounds];
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.colorName = @"Timeline_Notice_color";
        
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.font = [UIFont systemFontOfSize:13];
        [_badgeImageView addSubview:_badgeLabel];
    }
    if (count == 0)
    {
        _badgeImageView.hidden = YES;
    }
    else if (count > 99)
    {
        _badgeImageView.hidden = NO;
        _badgeLabel.text = @"99+";
    }
    else
    {
         _badgeImageView.hidden = NO;
        _badgeLabel.text = [NSString stringWithFormat:@"%li",count];
    }
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
