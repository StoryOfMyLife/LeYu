//
//  ActivitiesNearbyViewController.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/6/21.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ActivitiesNearbyViewController.h"
#import "ShopViewController.h"
#import "ActivityDetailViewController.h"
#import "ShopActivities.h"
#import "Shop.h"
#import "LYUser.h"
#import "LoginViewController.h"

@interface ActivitiesNearbyViewController ()

@property (nonatomic, strong) NSMutableArray *activitiesNearby;
@property (nonatomic, strong) NSMutableArray *myActivities;

@property (nonatomic, copy) NSArray *assets;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation ActivitiesNearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动";
    
    self.tableView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.activitiesNearby = [NSMutableArray array];
    self.myActivities = [NSMutableArray array];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:self.indicator];
    
    
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    [self.indicator startAnimating];
    
    weakSelf();
    self.updateBlock = ^{
        [weakSelf loadActivities:NO];
    };
}

-(void)navigateToLoginPage {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    UINavigationController *loginViewNavigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginViewNavigationController animated:YES completion:nil];
}

- (void)exitLoginProcess {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginCallback {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    LYUser *currentUser = [LYUser currentUser];
//    if (!currentUser) {
//        [self navigateToLoginPage];
//    }
}

- (void)updateActivities:(NSArray *)activities
{
    self.items = @[activities];
    [self.indicator stopAnimating];
    [self.tableView.header endRefreshing];
}

- (void)loadActivities:(BOOL)accepted
{
    if (!accepted && self.activitiesNearby.count > 0) {
        [self updateActivities:self.activitiesNearby];
        return;
    } else if (accepted && self.myActivities.count > 0) {
        [self updateActivities:self.myActivities];
        return;
    }
    
    AVQuery *query = [ShopActivities query];
    [query orderByDescending:@"createdAt"];
    
    if (accepted) {
        LYUser *currentUser = [LYUser currentUser];
        NSString *userId = currentUser.objectId;
        if (userId.length > 0) {
            [query whereKey:@"users" containsAllObjectsInArray:@[userId]];
        }
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities,NSError *error) {
        if (!error) {
            
            NSMutableSet *shopIds = [[NSMutableSet alloc] init];
            for (ShopActivities *activity in activities) {
                if (accepted) {
                    activity.accepted = accepted;
                } else {
                    activity.otherActivity = YES;
                }
                [shopIds addObject:activity.shop.objectId];
            }
            
            AVQuery *shopsQuery = [Shop query];
            [shopsQuery whereKey:@"objectId" containedIn:[shopIds allObjects]];
            
            NSMutableDictionary *recentShops = [NSMutableDictionary dictionary];
            [shopsQuery findObjectsInBackgroundWithBlock:^(NSArray *shops, NSError *error) {
                if (!error) {
                    for (Shop *shop in shops) {
                        [recentShops setObject:shop forKey:shop.objectId];
                    }
                    for (ShopActivities *activity in activities) {
                        activity.shop = recentShops[activity.shop.objectId];
                        
                        activity.actionBlock = ^(UITableView *tableView, NSIndexPath *indexPath){
                            [tableView deselectRowAtIndexPath:indexPath animated:YES];
                            ActivityDetailViewController *activitiesViewController = [[ActivityDetailViewController alloc] initWithActivities:self.activitiesNearby[indexPath.row]];
                            activitiesViewController.hidesBottomBarWhenPushed = YES;
                            [self.parentViewController.navigationController pushViewController:activitiesViewController animated:YES];
                        };
                        
                        activity.handleBlock = ^(NSDictionary *info){
                            UIView *sender = info[@"sender"];
                            CGRect rect = [self.view convertRect:sender.frame fromView:sender.superview];
                            rect.origin.y += 64;
                            
                            Shop *shop = info[@"shop"];
                            ShopViewController *shopViewController =[[ShopViewController alloc] initWithShop:shop];
                            shopViewController.presentedRect = rect;
                            
                            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shopViewController];
                            nav.transitioningDelegate = shopViewController;
                            nav.modalPresentationStyle = UIModalPresentationCustom;
                            [self presentViewController:nav animated:YES completion:nil];
                        };
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self updateActivities:activities];
                        if (accepted) {
                            [self.myActivities addObjectsFromArray:activities];
                        } else {
                            [self.activitiesNearby addObjectsFromArray:activities];
                        }

                    });
                }
                
            }];
        }
    }];
}

#pragma mark -
#pragma mark tableview delegate


#pragma mark -
#pragma mark - Getters and Setters


@end
