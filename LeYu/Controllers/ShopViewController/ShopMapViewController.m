//
//  ShopMapViewController.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/9/13.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ShopMapViewController.h"
#import "ShopMapCellItem.h"

@interface ShopMapViewController ()

@property (nonatomic, strong) Shop *shop;

@end

@implementation ShopMapViewController

- (instancetype)initWithShop:(Shop *)shop {
    if (self = [self init]) {
        self.shop = shop;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ShopMapCellItem *item = [[ShopMapCellItem alloc] init];
    item.shop = self.shop;
    
    self.items = @[@[item]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.refreshEnable = NO;
}

@end
