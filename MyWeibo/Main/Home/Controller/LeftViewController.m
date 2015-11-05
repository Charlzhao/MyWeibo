//
//  LeftViewController.m
//  MyWeibo
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "LeftViewController.h"
#import "MoreTableViewCell.h"
#import "ThemeLabel.h"
@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tabelView;
}
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _creatTabView];
}

- (void)_creatTabView
{
    _tabelView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tabelView.backgroundColor = [UIColor clearColor];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    [self.view addSubview:_tabelView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tabView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 5;
    }
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreTableViewCell" owner:nil options:nil] lastObject];
    }
    
    NSArray *array = @[@"无", @"偏移", @"偏移&缩放", @"旋转", @"视差"];
    NSArray *arr = @[@"小图", @"大图"];
    
    if (indexPath.section == 0)
    {
        cell.themeTextLabel.text = array[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        cell.themeTextLabel.text = arr[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 100;
    }
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    ThemeLabel *label = [[ThemeLabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    
    label.colorName = @"More_Item_Text_color";
    if (section == 0)
    {
        view.frame = CGRectMake(0, 0, 200, 100);
        label.text = @"界面切换效果";
        label.frame = CGRectMake(3, 65, 200, 30);
    }
    else
    {
        view.frame = CGRectMake(0, 0, 200, 70);
        label.text = @"图片浏览模式";
        label.frame = CGRectMake(3, 35, 200, 30);
    }
    [view addSubview:label];
    
    return view;
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
