//
//  ShopActivityViewController.h
//  LifeO2O
//
//  Created by 刘廷勇 on 15/9/13.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "LTableViewController.h"
#import "ShopActivities.h"

@interface ShopActivityViewController : LTableViewController

@property (nonatomic, strong) AVQuery *activityQuery;

@property (nonatomic, assign) BOOL couldShowShop;

@end
