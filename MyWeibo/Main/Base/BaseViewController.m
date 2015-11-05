//
//  BaseViewController.m
//  MyWeibo
//
//  Created by mac on 15/10/7.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManger.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "ThemeButton.h"
#import "ThemeImageView.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#import "UIProgressView+AFNetworking.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
{
    MBProgressHUD *_hud;
    UIView *_tipView;
    UIWindow *_tipWindow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _loadImage];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}

- (void)themeDidChange:(NSNotification *)notification
{
    [self _loadImage];
}

- (void)_loadImage
{
    ThemeManger *manger = [ThemeManger shareInstance];
    UIImage *image = [manger getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)setNavTtem
{
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setAction)];
    [self _createButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction)];
    
}

- (void)_createButton
{
    ThemeButton *leftButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    leftButton.backColorImageName = @"button_title.png";
    leftButton.normalImageName = @"group_btn_all_on_title.png";
    [leftButton setTitle:@"设置" forState:UIControlStateNormal];
//    leftButton.normalImageName = @"group_btn_all_on_title.png";
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftButton addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside ];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setAction{
    MMDrawerController *mmDraw = self.mm_drawerController;
    [mmDraw openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)editAction{
    MMDrawerController *mmDraw = self.mm_drawerController;
    [mmDraw openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showStatus:(NSString *)title show:(BOOL)show operation:(AFHTTPRequestOperation *)operation
{
    if (_tipWindow == nil)
    {
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor greenColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:_tipWindow.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor redColor];
        label.tag = 100;
        [_tipWindow addSubview:label];
        
        UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progress.frame = CGRectMake(0, 17, kScreenWidth, 5);
        progress.tag = 101;
        progress.progress = 0.0;
        [_tipWindow addSubview:progress];
    }
    UILabel *label = (UILabel *)[_tipWindow viewWithTag:100];
    label.text = title;
    
    UIProgressView *progressView = (UIProgressView *)[_tipWindow viewWithTag:101];
    if (show)
    {
        _tipWindow.hidden = NO;
        if (operation != nil)
        {
            progressView.hidden = NO;
            [progressView setProgressWithDownloadProgressOfOperation:operation animated:YES];
        }
        else
        {
            progressView.hidden = YES;
        }
    }
    else
    {
        [self performSelector:@selector(hideTipWindow) withObject:nil afterDelay:0.3];
    }
    
}

- (void)hideTipWindow
{
    _tipWindow.hidden = YES;
    _tipWindow = nil;
}


//HUD 三方实现进度
- (void)showHud:(NSString *)title
{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hud show:YES];
    _hud.labelText = title;
    _hud.dimBackground = YES;//阴影
    
}

- (void)hideHud
{
    [_hud hide:YES];
}


- (void)comleteHud:(NSString *)title
{
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.labelText = title;
    
    [_hud hide:YES afterDelay:1.5];
    
}




//#pragma mark 进度 提示
//
////自己实现
//- (void)showLoading:(BOOL)show{
//    
//    
//    if (_tipView == nil) {
//        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2-30, kScreenWidth, 20)];
//        _tipView.backgroundColor = [UIColor clearColor];
//        
//        //01 activity
//        UIActivityIndicatorView *activiyView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        activiyView.tag = 100;
//        [_tipView addSubview:activiyView];
//        
//        
//        //02 label
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//        label.backgroundColor = [UIColor clearColor];
//        label.text = @"正在加载。。。";
//        label.font = [UIFont systemFontOfSize:16];
//        label.textColor = [UIColor blackColor];
//        [label sizeToFit];
//        [_tipView addSubview:label];
//        
//        label.left = (kScreenWidth-label.width)/2;
//        activiyView.right = label.left-5;
//        
//    }
//    
//    
//    if (show) {
//        
//        UIActivityIndicatorView *activiyView =(UIActivityIndicatorView*) [_tipView viewWithTag:100];
//        [activiyView startAnimating];
//        [self.view addSubview:_tipView];
//    }else{
//        if (_tipView.superview)
//        {
//            UIActivityIndicatorView *activiyView = (UIActivityIndicatorView*)[_tipView viewWithTag:100];
//            [activiyView stopAnimating];
//            [_tipView removeFromSuperview];
//        }
//    }
//    
//}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
