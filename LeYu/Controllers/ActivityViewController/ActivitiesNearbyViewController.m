//
//  ActivitiesNearbyViewController.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/6/21.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ActivitiesNearbyViewController.h"
#import "ActivityDetailViewController.h"
#import "ShopActivities.h"
#import "Shop.h"
#import "LYUser.h"
#import "LoginViewController.h"
#import "LYLocationManager.h"

@interface ActivitiesNearbyViewController ()

@property (nonatomic, strong) NSMutableArray *activities;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) AVQuery *query;

@end

@implementation ActivitiesNearbyViewController

- (void)viewDidLoad
{
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
    self.items = @[activities];
    [self.indicator stopAnimating];
    [self.tableView.header endRefreshing];
}

- (void)loadActivities
{
    [[LYLocationManager sharedManager] getCurrentLocation:^(BOOL success, CLLocation *currentLocation) {
        if (success) {
            AVGeoPoint *currentGeo = [AVGeoPoint geoPointWithLocation:currentLocation];
            AVQuery *shopQuery = [Shop query];
            [shopQuery whereKey:@"geolocation" nearGeoPoint:currentGeo withinKilometers:10];
            
            AVQuery *activityQuery = [ShopActivities query];
            [activityQuery whereKey:@"shop" matchesQuery:shopQuery];
            [activityQuery includeKey:@"shop"];
            
            [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *activities,NSError *error) {
                if (!error) {
                    
                    [self.activities removeAllObjects];
                    [self.activities addObjectsFromArray:activities];
                    
                    for (ShopActivities *activity in activities) {
                        activity.otherActivity = YES;
                        
                        activity.actionBlock = ^(UITableView *tableView, NSIndexPath *indexPath){
                            [tableView deselectRowAtIndexPath:indexPath animated:YES];
                            ActivityDetailViewController *activitiesViewController = [[ActivityDetailViewController alloc] initWithActivities:self.activities[indexPath.row]];
                            activitiesViewController.hidesBottomBarWhenPushed = YES;
                            if (self.navigationController) {
                                [self.navigationController pushViewController:activitiesViewController animated:YES];
                            } else {
                                [self.parentViewController.navigationController pushViewController:activitiesViewController animated:YES];
                            }
                        };
                    }
                    [self updateActivities:activities];
                }
            }];
        }
    }];
}

@end
