//
//  ProfileViewController.m
//  MyWeibo
//
//  Created by mac on 15/10/7.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "WeiboModel.h"
#import "ProfileTableView.h"
#import "WeiboViewFrameLayout.h"
#import "ProfileTitleView.h"

@interface ProfileViewController ()<SinaWeiboRequestDelegate>

@end

@implementation ProfileViewController
{
    ProfileTableView *_tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self _creatTableView];
    [self timelineButtonPressed];
    //[self _creatProfileView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timelineButtonPressed
{
    //    ThemeManger *manger = [ThemeManger shareInstance];
    //    manger.themeName = @"Dark Fairy";
    
    AppDelegate *appDelegat = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = appDelegat.sinaweibo;
    [sinaweibo requestWithURL:@"statuses/user_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)_creatTableView
{
    //CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.height - 200)
    _tableView = [[ProfileTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
}

- (void)_creatProfileView
{
//    ProfileTitleView *view = [[ProfileTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    ProfileTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"ProfileView" owner:nil options:nil] lastObject];
    view.frame = CGRectMake(0, 64, kScreenWidth, 150);
    view.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:view];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    //    NSLog(@"%@",result);
    NSArray *statusesArray = [result objectForKey:@"statuses"];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in statusesArray)
    {
        WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic];
        WeiboViewFrameLayout *layout = [[WeiboViewFrameLayout alloc] init];
        layout.model = model;
        
        [dataArray addObject:layout];
    }
    _tableView.weiboArray = dataArray;
    [_tableView reloadData];
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
