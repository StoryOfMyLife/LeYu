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
        self.tableView.header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            if (self.updateBlock) {
                self.updateBlock();
            }
        }];
        
        MJRefreshGifHeader *header = (MJRefreshGifHeader *)self.tableView.header;
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < 25; i++) {
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"leyu%d", i]]];
        }
        // 设置普通状态的动画图片
        [header setImages:images forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//        [header setImages:images forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [header setImages:images duration:.5 forState:MJRefreshStateRefreshing];
        // 设置header

        header.stateLabel.hidden = YES;
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
    cell.indexPath = indexPath;
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LTableViewCellItem *item = [self tableView:tableView itemAtIndexPath:indexPath];
    
    [self tableView:tableView didSelectItem:item atIndexPath:indexPath];
    
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
        item.actionBlock(self.tableView, indexPath);
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
