//
//  ShopDescViewController.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/9/13.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ShopDescViewController.h"
#import "ShopInfoDescription.h"

@interface ShopDescViewController () 

@property (nonatomic, strong) Shop *shop;

@end

@implementation ShopDescViewController

- (instancetype)initWithShop:(Shop *)shop {
    if (self = [self init]) {
        self.shop = shop;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    AVQuery *query = [ShopInfoDescription query];
    [query whereKey:@"shop" equalTo:self.shop];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.items = @[objects];
    }];
}

#pragma mark -
#pragma mark Accessors 





@end
