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

@property (nonatomic, strong) AVQuery *query;
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
        return;
    }
    
    AVQuery *relationQuery = [ActivityUserRelation query];
    [relationQuery whereKey:@"user" equalTo:currentUser];
    
    [relationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *activityIds = [NSMutableArray array];
        
        for (ActivityUserRelation *relation in objects) {
            [activityIds addObject:relation.activity.objectId];
        }
        
        AVQuery *query = [ShopActivities query];
        [query orderByDescending:@"createdAt"];
        [query includeKey:@"shop"];
        [query whereKey:@"objectId" containedIn:activityIds];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
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
        
    }];
}

@end
