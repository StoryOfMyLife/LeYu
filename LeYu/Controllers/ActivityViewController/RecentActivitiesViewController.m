//
//  RecentActivitiesViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/11/28.
//  Copyright © 2015年 liuty. All rights reserved.
//

#import "RecentActivitiesViewController.h"
#import "ActivityDetailViewController.h"
#import "ActivityWebviewController.h"
#import "ShopActivities.h"
#import "Shop.h"
#import "LYUser.h"

@interface RecentActivitiesViewController ()

@property (nonatomic, strong) NSMutableArray *activities;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) AVQuery *query;

@end

@implementation RecentActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.backgroundColor = DefaultBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    RAC(self.tableView, scrollIndicatorInsets) = RACObserve(self.tableView, contentInset);
    
    self.activities = [NSMutableArray array];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.indicator];
    
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    [self.indicator startAnimating];
    
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
    [self.tableView.header endRefreshing];
    [self.indicator stopAnimating];
    if (activities.count == 0) {
        [self showNoData:@"附近没有活动"];
        return;
    }
    [self hideNoData];
    self.items = @[activities];
}

- (void)loadActivities
{
    AVQuery *activityQuery = [ShopActivities query];
    [activityQuery orderByDescending:@"createdAt"];
    [activityQuery whereKey:@"isApproved" equalTo:@(1)];
    
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *activities,NSError *error) {
        if (!error) {
            [self.activities removeAllObjects];
            [self.activities addObjectsFromArray:activities];
            
            for (ShopActivities *activity in activities) {
                activity.style = OtherActivityStyleRecent;
                
                if ([activity.activityType integerValue] == ActivityTypeNormal) {
                    activity.actionBlock = ^(UITableView *tableView, NSIndexPath *indexPath){
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                        ActivityDetailViewController *activitiesViewController = [[ActivityDetailViewController alloc] initWithActivities:self.activities[indexPath.row]];
                        activitiesViewController.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:activitiesViewController animated:YES];
                    };
                } else {
                    @weakify(activity);
                    activity.actionBlock = ^(UITableView *tableView, NSIndexPath *indexPath){
                        @strongify(activity);
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                        ActivityWebviewController *webVC = [[ActivityWebviewController alloc] init];
                        webVC.activity = activity;
                        [self.navigationController pushViewController:webVC animated:YES];
                        webVC.urlID = activity.objectId;
                    };
                }
            }
            [self updateActivities:activities];
        } else {
            [self showNoData:@"数据异常"];
        }
    }];
}

@end
