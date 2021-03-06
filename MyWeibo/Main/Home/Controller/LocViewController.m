//
//  LocViewController.m
//  MyWeibo
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "LocViewController.h"
#import "DataService.h"
#import "PoiModel.h"
#import "UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>
@interface LocViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    UITableView *_tableView;
    CLLocationManager *_locationManager;
}
@end

@implementation LocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initView];
    [self _locationManger];
    
}

- (void)_initView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style: UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

- (void)_locationManger
{
    _locationManager = [[CLLocationManager alloc] init];
    if (kVersion >= 8.0)
    {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    _locationManager.delegate = self;
    
    [_locationManager startUpdatingLocation];
}

// 开始加载网络
- (void)loadNearByPoisWithlon:(NSString *)lon lat:(NSString *)lat
{
    // 01配置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:lon forKey:@"long"];//经度
    [params setObject:lat forKey:@"lat"];
    [params setObject:@50 forKey:@"count"];
    
    //请求数据
    
    //获取附近商家
    __weak __typeof(self) weakSelf = self;
    [DataService requestUrl:nearby_pois httpMethod:@"GET" params:params block:^(id result) {
        
        NSArray *pois = result[@"pois"];
        NSMutableArray *dataList = [NSMutableArray array];
        for (NSDictionary *dic in pois) {
            // 创建商圈模型对象
            PoiModel *poi = [[PoiModel alloc]initWithDataDic:dic];
            [dataList addObject:poi];
        }
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.dataList = dataList;
        [strongSelf->_tableView reloadData];
        
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 停止定位
    [manager stopUpdatingLocation];
    
    // 获取当前请求的位置
    CLLocation *location = [locations lastObject];
    
    NSString *lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    // 开始加载网络
    [self loadNearByPoisWithlon:lon lat:lat];
}

#pragma mark - tableViewDelegat,tableViewdataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    // 获取当前单元格对应的商圈对象
    PoiModel *poi = self.dataList[indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:poi.icon] placeholderImage:[UIImage imageNamed:@"icon"]];
    cell.textLabel.text = poi.title;
    
    return cell;
}


@end
