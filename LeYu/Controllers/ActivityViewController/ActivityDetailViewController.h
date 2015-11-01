//
//  ActivitiesViewController.h
//  LifeO2O
//
//  Created by jiecongwang on 5/28/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopActivities.h"
#import "LTableViewController.h"

@interface ActivityDetailViewController : LTableViewController

- (instancetype)initWithActivities:(ShopActivities *)activities;

- (void)didAccept;

@end
