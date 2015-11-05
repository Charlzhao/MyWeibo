//
//  WeiboTabView.m
//  MyWeibo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboTabView.h"
#import "WeiboModel.h"
#import "WeiboCell.h"
#import "WeiboViewFrameLayout.h"
#import "DetailViewController.h"
#import "UIView+ViewController.h"
@implementation WeiboTabView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        [self _creatTableView];
    }
    return self;
}

- (void)_creatTableView
{
    self.dataSource = self;
    self.delegate = self;
    
}

#pragma mark - tableview datasouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _weiboArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WeiboCell" owner:self options:nil] lastObject];
    }
    
//    WeiboModel *model = _weiboArray[indexPath.row];
    WeiboViewFrameLayout *layout = _weiboArray[indexPath.row];
    
    cell.layout = layout;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboViewFrameLayout *layout = _weiboArray[indexPath.row];
    return layout.frame.size.height + 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *view = [[DetailViewController alloc] init];
    WeiboViewFrameLayout *layoutFrame = _weiboArray[indexPath.row];
    view.weiboModel = layoutFrame.model;
    
    [self.viewController.navigationController pushViewController:view animated:YES];
}

@end
