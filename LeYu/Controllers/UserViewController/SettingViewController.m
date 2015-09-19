//
//  SettingViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/20.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)logout:(id)sender
{
    [LYUser logOut];
    [self.userVC updateAvatar];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
