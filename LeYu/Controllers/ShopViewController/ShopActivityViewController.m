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

@property (nonatomic, strong) NSMutableDictionary *recentShops;


@end

@implementation ShopActivityViewController

@synthesize activityQuery = _activityQuery;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.recentActivities = [[NSMutableArray alloc] init];
        self.recentShops = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    
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
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities,NSError *error) {
        if (!error) {
            [self.recentActivities removeAllObjects];
            [self.recentActivities addObjectsFromArray:activities];
            NSMutableSet *shopIds = [[NSMutableSet alloc] init];
            for (ShopActivities *activity in activities) {
                [shopIds addObject:activity.shop.objectId];
            }
            
            AVQuery *shops = [Shop query];
            [shops whereKey:@"objectId" containedIn:[shopIds allObjects]];
            [shops findObjectsInBackgroundWithBlock:^(NSArray *shops, NSError *error) {
                if (!error) {
                    for (Shop *shop in shops) {
                        [self.recentShops setObject:shop forKey:shop.objectId];
                    }
                    for (ShopActivities *activity in self.recentActivities) {
                        activity.shop = self.recentShops[activity.shop.objectId];
                        activity.actionBlock = ^(UITableView *tableView, NSIndexPath *indexPath){
                            [tableView deselectRowAtIndexPath:indexPath animated:YES];
                            ActivityDetailViewController *activitiesViewController = [[ActivityDetailViewController alloc] initWithActivities:self.recentActivities[indexPath.row]];
                            activitiesViewController.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:activitiesViewController animated:YES];
                        };
                        
                        if (self.couldShowShop) {
                            activity.handleBlock = ^(NSDictionary *info){
                                UIView *sender = info[@"sender"];
                                CGRect rect = [self.view convertRect:sender.frame fromView:sender.superview];
                                rect.origin.y += self.navigationController.navigationBar.height + 20;
                                
                                Shop *shop = info[@"shop"];
                                
                                ShopViewController *s = [[ShopViewController alloc] initWithShop:shop];
                                s.presentedRect = rect;
                                
                                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:s];
                                nav.transitioningDelegate = s;
                                nav.modalPresentationStyle = UIModalPresentationCustom;
                                [self presentViewController:nav animated:YES completion:nil];
                            };
                        }
                    }
                    [self updateActivities:self.recentActivities];
                }
            }];
            
        } else {
            [self updateActivities:self.recentActivities];
        }
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
