//
//  LTableViewController.m
//  LBase
//
//  Created by 刘廷勇 on 15/4/7.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "LTableViewController.h"
#import "LTableViewCell.h"
#import "LTableViewCellItem.h"

@interface LTableViewController ()

@end

@implementation LTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[[self tableViewClass] alloc] initWithFrame:CGRectZero style:[self tableViewStyle]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 49.0f;
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.refreshEnable = YES;
}

- (Class)tableViewClass
{
    return [UITableView class];
}

- (UITableViewStyle)tableViewStyle
{
    return UITableViewStylePlain;
}

- (void)setItems:(NSArray *)items
{
    _items = items;
    [self.tableView reloadData];
}

- (void)_setItems:(NSArray *)items
{
    _items = items;
}

- (void)setRefreshEnable:(BOOL)refreshEnable
{
    _refreshEnable = refreshEnable;
    if (!refreshEnable) {
        self.tableView.header = nil;
        if (self.updateBlock) {
            self.updateBlock();
        }
    } else {
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            if (self.updateBlock) {
                self.updateBlock();
            }
        }];
        MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.tableView.header;
        header.arrowView.image = nil;
        header.lastUpdatedTimeLabel.hidden = YES;
        //     马上进入刷新状态
        [self.tableView.header beginRefreshing];
    }
}

#pragma mark -
#pragma mark Table View Delegate and Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LTableViewCellItem *item = [self tableView:tableView itemAtIndexPath:indexPath];
    LTableViewCell *cell = [[item cellClass] dequeueCellForTableView:tableView];
    cell.tableView = tableView;
    cell.cellItem = item;
    item.cell = cell;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LTableViewCellItem *item = [self tableView:tableView itemAtIndexPath:indexPath];
    return [item heightForTableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert([NSThread isMainThread], @"非主线程");
    
    LTableViewCellItem *item = [self tableView:tableView itemAtIndexPath:indexPath];
    
    [self tableView:tableView didSelectItem:item atIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items[section] count];
}

#pragma mark -
#pragma mark LTableViewDelegate

//When override, must call super
- (void)tableView:(UITableView *)tableView didSelectItem:(LTableViewCellItem *)item atIndexPath:(NSIndexPath *)indexPath
{
    if (item.actionBlock) {
        [tableView beginUpdates];
        item.actionBlock(self.tableView, indexPath);
        [tableView endUpdates];
    }
}

- (id)tableView:(UITableView *)tableView itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[indexPath.section][indexPath.row];
}

#pragma mark -
#pragma mark UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(LTableViewDidScroll:)]) {
        [self.delegate LTableViewDidScroll:scrollView];
    }
}

@end
