//
//  MyAcceptedActivityViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/21.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "MyAcceptedActivityViewController.h"
#import "ActivityUserRelation.h"
#import "ActivityDetailViewController.h"

@interface MyAcceptedActivityViewController ()

@property (nonatomic, strong) NSMutableArray *activities;

@end

@implementation MyAcceptedActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.backgroundColor = DefaultBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    if (activities.count == 0) {
        [self showNoData:@"没有参与活动"];
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
    
    AVQuery *relationQuery = [ActivityUserRelation query];
    [relationQuery whereKey:@"user" equalTo:currentUser];

    AVQuery *query = [ShopActivities query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"shop"];
    [query whereKey:@"objectId" matchesKey:@"activity.objectId" inQuery:relationQuery];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [self showNoData:@"数据异常"];
            return;
        }
        [self.activities removeAllObjects];
        [self.activities addObjectsFromArray:objects];
        for (ShopActivities *activity in objects) {
            activity.accepted = YES;
            
            activity.actionBlock = ^(UITableView *tableView, NSIndexPath *indexPath){
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                ActivityDetailViewController *activitiesViewController = [[ActivityDetailViewController alloc] initWithActivities:self.activities[indexPath.row]];
                activitiesViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:activitiesViewController animated:YES];
            };
        }
        [self updateActivities:self.activities];
    }];
}

@end
