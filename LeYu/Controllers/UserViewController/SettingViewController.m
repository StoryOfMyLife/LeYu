//
//  SettingViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/20.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "SettingViewController.h"
#import <LeanCloudFeedback/LeanCloudFeedback.h>

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
        hud.removeFromSuperViewOnHide = YES;
        hud.detailsLabelText = @"正在清除缓存...";
        [self.view addSubview:hud];
        [AVFile clearAllCachedFiles];
        [hud show:YES];
        [hud hide:YES afterDelay:3];
    } else if (indexPath.row == 2) {
        LCUserFeedbackViewController *feedbackViewController = [[LCUserFeedbackViewController alloc] init];
        feedbackViewController.navigationBarStyle = LCUserFeedbackNavigationBarStyleNone;
        feedbackViewController.contactHeaderHidden = YES;
        feedbackViewController.feedbackTitle = [LYUser currentUser].username;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
        [self presentViewController:navigationController animated:YES completion: ^{
        }];
    }
}

- (IBAction)logout:(id)sender
{
    [LYUser logOut];
    [self.userVC updateAvatar];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
