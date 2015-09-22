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
#import "LYLocationManager.h"

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
    
    AVQuery *query = [ShopActivities query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"shop"];
    [query whereKey:@"shop" matchesQuery:shopQuery];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [[LYLocationManager sharedManager] getCurrentLocation:^(BOOL success, CLLocation *currentLocation) {
            NSArray *activities = [objects sortedArrayUsingComparator:^NSComparisonResult(ShopActivities *obj1, ShopActivities *obj2) {
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
                activity.accepted = YES;
                
                activity.actionBlock = ^(UITableView *tableView, NSIndexPath *indexPath){
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    ActivityDetailViewController *activitiesViewController = [[ActivityDetailViewController alloc] initWithActivities:self.activities[indexPath.row]];
                    activitiesViewController.hidesBottomBarWhenPushed = YES;
                    [self.parentViewController.navigationController pushViewController:activitiesViewController animated:YES];
                };
            }
            [self updateActivities:activities];
        }];
    }];

}

@end
