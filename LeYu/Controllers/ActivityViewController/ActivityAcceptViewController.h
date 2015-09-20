//
//  ActivityAcceptViewController.h
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/30.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "LTableViewController.h"
#import "ShopActivities.h"

@interface ActivityAcceptViewController : LTableViewController <UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) CGRect presentedRect;

@property (nonatomic, strong) ShopActivities *activity;

@end
