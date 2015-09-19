//
//  UserInfoEditViewController.h
//  LeYu
//
//  Created by 刘廷勇 on 15/9/19.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserViewController.h"

@interface UserInfoEditViewController : UITableViewController

@property (nonatomic, assign, getter=isShopUser) BOOL shopUser;

@property (nonatomic, weak) UserViewController *userVC;

@end
