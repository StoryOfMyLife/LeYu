//
//  LTableViewController.h
//  LBase
//
//  Created by 刘廷勇 on 15/4/7.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "LViewController.h"
#import "LTableViewDelegate.h"
#import <MJRefresh.h>

@protocol LTableViewScrollDelegate;

@interface LTableViewController : LViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, LTableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, assign) BOOL refreshEnable;

@property (nonatomic, copy) dispatch_block_t updateBlock;

@property (nonatomic, weak) id <LTableViewScrollDelegate> delegate;

- (void)_setItems:(NSArray *)items;

@end


@protocol LTableViewScrollDelegate <NSObject>

- (void)LTableViewDidScroll:(UIScrollView *)tableView;

@end
