//
//  HomeViewController.m
//  MyWeibo
//
//  Created by mac on 15/10/7.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "WeiboTabView.h"
#import "WeiboModel.h"
#import "WeiboViewFrameLayout.h"
#import "MJRefresh.h"
#import "ThemeImageView.h"
#import <AudioToolbox/AudioToolbox.h>
@interface HomeViewController ()

@end

@implementation HomeViewController
{
    WeiboTabView *_tableView;
    NSMutableArray *_data;
    ThemeImageView *_barImageView;
    ThemeLabel *_barLabel;
}

- (void)_creatTableView
{
    _tableView = [[WeiboTabView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    
}

- (void)_loadMoreData
{
    NSLog(@"加载更多");
    AppDelegate *appDelegat = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = appDelegat.sinaweibo;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"10" forKey:@"count"];
    //设置maxId
    if (_data.count > 0)
    {
        WeiboViewFrameLayout *layout = [_data lastObject];
        WeiboModel *model = layout.model;
        [params setObject:model.weiboIdStr forKey:@"max_id"];
    }
    
    SinaWeiboRequest *request = [sinaweibo requestWithURL:@"statuses/home_timeline.json"
                                                   params:params
                                               httpMethod:@"GET"
                                                 delegate:self];
    
    request.tag = 102;
}

- (void)_loadNewData
{
    NSLog(@"下拉刷新");
    
    AppDelegate *appDelegat = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = appDelegat.sinaweibo;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"10" forKey:@"count"];
    //设置sinceId
    if (_data.count > 0)
    {
        WeiboViewFrameLayout *layout = _data[0];
        WeiboModel *model = layout.model;
        [params setObject:model.weiboIdStr forKey:@"since_id"];
    }
    
    SinaWeiboRequest *request = [sinaweibo requestWithURL:@"statuses/home_timeline.json"
                                                   params:params
                                               httpMethod:@"GET"
                                                 delegate:self];
    
    request.tag = 101;
}


- (void)timelineButtonPressed
{
    [self showHud:@"正在加载..."];
    
    AppDelegate *appDelegat = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = appDelegat.sinaweibo;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"10" forKey:@"count"];
 
    SinaWeiboRequest *request = [sinaweibo requestWithURL:@"statuses/home_timeline.json"
                                                   params:params
                                               httpMethod:@"GET"
                                                 delegate:self];
    
    request.tag = 100;
}

//- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response;
//- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data;
//- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error;
//- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result;
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
    
    if (request.tag == 100)
    {
        _data = dataArray;
        
        [self comleteHud:@"加载完成"];
    }
    else if (request.tag == 101)
    {
        if (_data == nil)
        {
            _data = dataArray;
        }
        else
        {
            NSRange range = NSMakeRange(0, dataArray.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [_data insertObjects:dataArray atIndexes:indexSet];
            
            [self showNewWeiboCount:dataArray.count];
        }
        
    }
    else if (request.tag == 102)
    {
        if (_data == nil)
        {
            _data = dataArray;
        }
        else
        {
            [_data removeLastObject];
            [_data addObjectsFromArray:dataArray];
        }
    }
    if (_data.count != 0)
    {
        _tableView.weiboArray = _data;
        [_tableView reloadData];
    }
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTtem];
    [self _creatTableView];
    [self timelineButtonPressed];

}


- (void)showNewWeiboCount:(NSInteger) count
{
    if (_barImageView == nil)
    {
        _barImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(5, -40, kScreenWidth-10, 40)];
        _barImageView.imageName = @"timeline_notify.png";
        [self.view addSubview:_barImageView];
        
        _barLabel = [[ThemeLabel alloc] initWithFrame:_barImageView.bounds];
        _barLabel.colorName  = @"Timeline_Notice_color";
        _barLabel.backgroundColor = [UIColor clearColor];
        _barLabel.textAlignment = NSTextAlignmentCenter;
        
        [_barImageView addSubview:_barLabel];
    }
    if (count > 0)
    {
        _barLabel.text = [NSString stringWithFormat:@"更新了%li条微博",count];
        
        [UIView animateWithDuration:0.6 animations:^{
            _barImageView.transform = CGAffineTransformMakeTranslation(0, 64 + 40 + 3);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 animations:^{
                [UIView setAnimationDelay:1];
                _barImageView.transform = CGAffineTransformIdentity;
            }];
        }];
        
        //#import <AudioToolbox/AudioToolbox.h>
        //播放声音
        NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:path];
        //注册系统声音
        SystemSoundID soundId;// 0
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
        
        AudioServicesPlaySystemSound(soundId);
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
