//
//  NewNotificationsViewController.m
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/22.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "NewNotificationsViewController.h"
#import "MessageCellItem.h"
#import "ActivityUserRelation.h"
#import "NSDate+Compare.h"

@interface NewNotificationsViewController ()

@property (nonatomic, strong) NSMutableArray *notifications;
@property (nonatomic, assign) BOOL isLogined;

@end

@implementation NewNotificationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";
    
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = DefaultBackgroundColor;
    self.tableView.tableFooterView = [UIView new];
    
    [self loadActivities];
    weakSelf();
    self.updateBlock = ^{
        [weakSelf loadActivities];
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.isLogined) {
        [self loadActivities];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.tabBarItem.badgeValue = nil;
}

#pragma mark -
#pragma mark methods

- (void)updateActivities:(NSArray *)activities
{
    [self.tableView.header endRefreshing];
    if (activities.count == 0) {
        [self showNoData:@"没有消息"];
        return;
    }
    [self hideNoData];
    self.items = @[activities];
    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)[activities count]];
}

- (void)loadActivities
{
    LYUser *currentUser = [LYUser currentUser];
    if (!currentUser) {
        [self showNoData:@"请先登录"];
        self.isLogined = NO;
        [self.tableView.header endRefreshing];
        return;
    } else {
        self.isLogined = YES;
    }
    
    AVQuery *relationQuery = [ActivityUserRelation query];
    [relationQuery includeKey:@"activity"];
    [relationQuery includeKey:@"activity.shop"];
    [relationQuery whereKey:@"user" equalTo:currentUser];
    [relationQuery whereKey:@"userArriveDate" greaterThanOrEqualTo:[NSDate date]];
    
    [relationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            [self showNoData:@"数据异常"];
            return;
        }
        NSMutableArray *messages = [NSMutableArray array];
        for (ActivityUserRelation *relation in objects) {
            if ([relation.userArriveDate isSameDay:[NSDate date]]) {
                MessageCellItem *item = [[MessageCellItem alloc] init];
                item.activity = relation.activity;
                [messages addObject:item];
            }
        }
        [self updateActivities:messages];
    }];
}

@end
