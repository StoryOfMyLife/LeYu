//
//  SettingViewController.h
//  LeYu
//
//  Created by 刘廷勇 on 15/9/20.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserViewController.h"

#define kUserDidLogoutNotification @"kUserDidLogoutNotification" 

@interface SettingViewController : UITableViewController

@property (nonatomic, weak) UserViewController *userVC;

@end
