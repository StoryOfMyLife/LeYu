//
//  ActivityOfFollowedShopViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/21.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "ActivityOfFollowedShopViewController.h"
#import "ShopActivities.h"
#import "ActivityDetailViewController.h"

@interface ActivityOfFollowedShopViewController ()

@property (nonatomic, strong) AVQuery *query;
@property (nonatomic, strong) NSMutableArray *activities;

@end

@implementation ActivityOfFollowedShopViewController

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
    weakSelf();
    self.updateBlock = ^{
        [weakSelf loadActivities];
    };
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
        //TODO:显示未登录
        return;
    }
    
    AVQuery *shopQuery = [Shop query];
    [shopQuery whereKey:@"followers" equalTo:currentUser];
    [shopQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        AVQuery *query = [ShopActivities query];
        [query orderByDescending:@"createdAt"];
        [query includeKey:@"shop"];
        [query whereKey:@"shop" containedIn:objects];
        self.query = query;
        
        [self.query findObjectsInBackgroundWithBlock:^(NSArray *activities,NSError *error) {
            if (!error) {
                
                [self.activities removeAllObjects];
                [self.activities addObjectsFromArray:activities];
                
                for (ShopActivities *activity in activities) {
                    activity.accepted = YES;
                    
                    activity.actionBlock = ^(UITableView *tableView, NSIndexPath *indexPath){
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                        ActivityDetailViewController *activitiesViewController = [[ActivityDetailViewController alloc] initWithActivities:self.activities[indexPath.row]];
                        activitiesViewController.hidesBottomBarWhenPushed = YES;
                        [self.parentViewController.navigationController pushViewController:activitiesViewController animated:YES];
                    };
                }
                [self updateActivities:activities];
            }
        }];
    }];
}

@end
