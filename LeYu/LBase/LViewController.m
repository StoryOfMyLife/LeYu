//
//  LViewController.m
//  LBase
//
//  Created by 刘廷勇 on 15/4/7.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "LViewController.h"
#import "UITabBarController+AddButton.h"
#import "LYUser.h"

@interface LViewController ()

@end

@implementation LViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setNavigationBackgroundClear:(BOOL)clear
{
    [self.navigationController.navigationBar setBackgroundImage:clear ? [UIImage new] : nil
                                                  forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = clear ? [UIImage new] : nil;
    self.navigationController.navigationBar.translucent = clear;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UITabBarController *tabBarController = (UITabBarController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    if (![tabBarController showingAddButton]) {
        LYUser *currentUser = [LYUser currentUser];
        if (currentUser.shop) {
            [tabBarController showAddButton];
            
        } else {
            [tabBarController hideAddButton];
        }
    }
}

@end
