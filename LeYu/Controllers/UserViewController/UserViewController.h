//
//  UserViewController.h
//  LeYu
//
//  Created by 刘廷勇 on 15/9/19.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

@interface UserViewController : UITableViewController

@property (nonatomic, assign, getter=isShopUser) BOOL shopUser;

- (void)updateAvatar;

@end
