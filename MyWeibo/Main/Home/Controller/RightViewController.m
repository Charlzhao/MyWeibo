//
//  RightViewController.m
//  MyWeibo
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeButton.h"
#import "UIViewController+MMDrawerController.h"
#import "SendViewController.h"
#import "BaseNavigationController.h"
#import "LocViewController.h"
@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_createBtn
{
    NSArray *imageNames = @[@"newbar_icon_1.png",
                            @"newbar_icon_2.png",
                            @"newbar_icon_3.png",
                            @"newbar_icon_4.png",
                            @"newbar_icon_5.png"];
    for (int i = 0; i < 5; i++)
    {
        ThemeButton *btn = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 64 + i * 50, 40, 40)];
        btn.tag = i;
        btn.normalImageName = imageNames[i];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
}


- (void)btnAction:(ThemeButton *)button
{
    if (button.tag == 0)
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            
            SendViewController *sendView = [[SendViewController alloc] init];
            sendView.title = @"发送微博";
            
            
            BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:sendView];
            [self.mm_drawerController presentViewController:nav animated:YES completion:nil];
        }];
    }
    else if (button.tag == 4)
    {
        // 附近地点
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            
            
            LocViewController *vc = [[LocViewController alloc] init];
            vc.title = @"附近商圈";
            
            // 创建导航控制器
            BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [self.mm_drawerController presentViewController:baseNav animated:YES completion:nil];
        }];
        
        
    }
    
    
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
