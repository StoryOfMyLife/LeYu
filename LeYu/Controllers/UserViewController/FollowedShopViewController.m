//
//  FollowedShopViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/21.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "FollowedShopViewController.h"
#import "ShopFollowedCellItem.h"
#import "ShopViewController.h"

@interface FollowedShopViewController ()

@end

@implementation FollowedShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.backgroundColor = DefaultBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    RAC(self.tableView, scrollIndicatorInsets) = RACObserve(self.tableView, contentInset);
    
    [self loadActivities];
    self.refreshEnable = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -
#pragma mark methods

- (void)updateActivities:(NSArray *)activities
{
    if (activities.count == 0) {
        [self showNoData:@"没有收藏店铺"];
        return;
    }
    [self hideNoData];
    self.items = @[activities];
    [self.tableView.header endRefreshing];
}

- (void)loadActivities
{
    LYUser *currentUser = [LYUser currentUser];
    if (!currentUser) {
        [self showNoData:@"请先登录"];
        return;
    }
    
    AVQuery *shopQuery = [Shop query];
    [shopQuery whereKey:@"followers" equalTo:currentUser];
    
    [shopQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [self showNoData:@"数据异常"];
            return;
        }
        NSMutableArray *shopItems = [NSMutableArray arrayWithCapacity:0];
        for (Shop *shop in objects) {
            ShopFollowedCellItem *item = [[ShopFollowedCellItem alloc] init];
            item.shop = shop;
            [shopItems addObject:item];
            
            item.actionBlock = ^(UITableView *tableView, NSIndexPath *indexPath){
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                ShopViewController *s = [[ShopViewController alloc] initWithShop:shop];
                [self.navigationController pushViewController:s animated:YES];
            };
        }
        [self updateActivities:shopItems];
    }];
}

@end
