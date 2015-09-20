//
//  ShopActivityViewController.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/9/13.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ShopActivityViewController.h"

#import "ShopViewController.h"
#import "ActivityDetailViewController.h"

#import "Shop.h"

@interface ShopActivityViewController ()

@property (nonatomic, strong) NSArray *activities;

@property (nonatomic, strong) NSMutableArray *recentActivities;


@end

@implementation ShopActivityViewController

@synthesize activityQuery = _activityQuery;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recentActivities = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = DefaultBackgroundColor;
    self.tableView.scrollsToTop = YES;
    
    self.couldShowShop = YES;
    
    weakSelf();
    self.updateBlock = ^{
        [weakSelf loadActivities:weakSelf.activityQuery];
    };
}

- (AVQuery *)activityQuery
{
    if (!_activityQuery) {
        _activityQuery = [ShopActivities query];
        [_activityQuery orderByDescending:@"createdAt"];
    }
    return _activityQuery;
}

- (void)setActivityQuery:(AVQuery *)activityQuery
{
    if (_activityQuery != activityQuery) {
        [activityQuery orderByDescending:@"createdAt"];
        _activityQuery = activityQuery;
        [self loadActivities:activityQuery];
    }
}

- (void)loadActivities:(AVQuery *)query
{
    [query includeKey:@"shop"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities,NSError *error) {
        if (!error) {
            for (ShopActivities *activity in activities) {
                [self.recentActivities removeAllObjects];
                [self.recentActivities addObjectsFromArray:activities];
                activity.actionBlock = ^(UITableView *tableView, NSIndexPath *indexPath){
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    ActivityDetailViewController *activitiesViewController = [[ActivityDetailViewController alloc] initWithActivities:self.recentActivities[indexPath.row]];
                    activitiesViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:activitiesViewController animated:YES];
                };
                
                if (self.couldShowShop) {
                    __weak ShopActivities *shopActivity = activity;
                    activity.handleBlock = ^(NSDictionary *info){
                        UIView *sender = info[@"sender"];
                        CGRect rect = [self.view convertRect:sender.frame fromView:sender.superview];
                        rect.origin.y += self.navigationController.navigationBar.height + 20;
                        
                        Shop *shop = shopActivity.shop;
                        
                        ShopViewController *s = [[ShopViewController alloc] initWithShop:shop];
                        s.presentedRect = rect;
                        
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:s];
                        nav.transitioningDelegate = s;
                        nav.modalPresentationStyle = UIModalPresentationCustom;
                        [self presentViewController:nav animated:YES completion:nil];
                    };
                }
            }
        }
        [self updateActivities:activities];
    }];
}

- (void)updateActivities:(NSArray *)activities
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.items = @[activities];
        [self.tableView.header endRefreshing];
    });
}

@end
