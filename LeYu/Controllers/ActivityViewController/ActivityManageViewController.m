//
//  ActivityManageViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/21.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "ActivityManageViewController.h"
#import "ActivityManageDetailViewController.h"
#import "ShopActivities.h"
#import "ActivityManageCellItem.h"

@interface ActivityManageViewController ()

@property (nonatomic, strong) NSMutableArray *activities;

@end

@implementation ActivityManageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.backgroundColor = DefaultBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    RAC(self.tableView, scrollIndicatorInsets) = RACObserve(self.tableView, contentInset);
    
    self.activities = [NSMutableArray array];
    
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
    self.items = @[activities];
    [self.tableView.header endRefreshing];
}

- (void)loadActivities
{
    LYUser *currentUser = [LYUser currentUser];
    if (!currentUser) {
        return;
    }
    
    AVQuery *shopQuery = [Shop query];
    [shopQuery whereKey:@"objectId" equalTo:currentUser.shop.objectId];
    
    AVQuery *query = [ShopActivities query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"shop"];
    [query whereKey:@"shop" matchesQuery:shopQuery];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.activities removeAllObjects];
        [self.activities addObjectsFromArray:objects];
        
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
        for (ShopActivities *activity in objects) {
            ActivityManageCellItem *item = [[ActivityManageCellItem alloc] init];
            item.activity = activity;
            [items addObject:item];
            
            item.actionBlock = ^(UITableView *tableView, NSIndexPath *indexPath){
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                ActivityManageDetailViewController *vc = [[ActivityManageDetailViewController alloc] init];
                vc.activity = activity;
                [self.navigationController pushViewController:vc animated:YES];
            };
        }
        
        [self updateActivities:items];
    }];
}

@end