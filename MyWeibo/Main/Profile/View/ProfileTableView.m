//
//  ProfileTableView.m
//  MyWeibo
//
//  Created by mac on 15/10/14.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ProfileTableView.h"
#import "WeiboModel.h"
#import "WeiboCell.h"
#import "WeiboViewFrameLayout.h"
#import "ProfileTitleView.h"
@implementation ProfileTableView


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
//    if (indexPath.row == 0)
//    {
//        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileCell"];
//        if (cell == nil)
//        {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:self options:nil] lastObject];
//        }
//        
//        return cell;
//    }
    
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WeiboCell" owner:self options:nil] lastObject];
    }
    
    //    WeiboModel *model = _weiboArray[indexPath.row];
    WeiboViewFrameLayout *layout = _weiboArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.layout = layout;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboViewFrameLayout *layout = _weiboArray[indexPath.row];
    return layout.frame.size.height + 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    UIView *view = [[UIView alloc] init];
    //    view.backgroundColor = [UIColor yellowColor];
    //    return view;
    ProfileTitleView *view = [[[NSBundle mainBundle] loadNibNamed:@"ProfileView" owner:nil options:nil] lastObject];
    //view.backgroundColor = [UIColor lightGrayColor];
    
    view.layout = _weiboArray[section];
    
    return view;
}

@end
