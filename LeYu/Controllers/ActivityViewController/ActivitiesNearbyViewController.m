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
    if (activities.count == 0) {
        self showNoData:@"附近没有活动";
        return;
    }
    [self hideNoData];
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
            [shopQuery whereKey:@"geolocation" nearGeoPoint:currentGeo withinKilometers:100000];
        
            AVQuery *activityQuery = [ShopActivities query];
            [activityQuery whereKey:@"shop" matchesQuery:shopQuery];
            [activityQuery includeKey:@"shop"];
            
            [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *activities,NSError *error) {
                if (!error) {
                    activities = [activities sortedArrayUsingComparator:^NSComparisonResult(ShopActivities *obj1, ShopActivities *obj2) {
                        AVGeoPoint *geo1 = obj1.shop.geolocation;
                        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:geo1.latitude longitude:geo1.longitude];
                        CLLocationDistance distance1 = [currentLocation distanceFromLocation:location1];
                        
                        AVGeoPoint *geo2 = obj2.shop.geolocation;
                        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:geo2.latitude longitude:geo2.longitude];
                        CLLocationDistance distance2 = [currentLocation distanceFromLocation:location2];
                        if (distance1 < distance2) {
                            return NSOrderedAscending;
                        }
                        if (distance1 > distance2) {
                            return NSOrderedDescending;
                        }
                        return NSOrderedSame;
                    }];
                    
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
                } else {
                    [self showNoData:@"数据异常"];
                }
            }];
        } else {
            [self showNoData:@"定位失败"];
        }
    }];
}

@end
