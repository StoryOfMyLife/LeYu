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

#pragma mark -
#pragma mark methods

- (void)updateActivities:(NSArray *)activities
{
    if (activities.count == 0) {
        [self showNoData:@"没有消息"];
        return;
    }
    [self hideNoData];
    self.items = @[activities];
    [self.tableView.header endRefreshing];
}

- (void)loadActivities
{
    LYUser *currentUser = [LYUser currentUser];
    
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
