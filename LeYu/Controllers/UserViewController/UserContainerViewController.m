//
//  UserContainerViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/19.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "UserContainerViewController.h"
#import "UserViewController.h"
#import "UserProfileLoginView.h"
#import "LoginViewController.h"

@interface UserContainerViewController () <UserProfileLoginDelegate>

@property (nonatomic, strong) UserViewController *userVC;

@property (nonatomic, strong) UserProfileLoginView *loginView;

@property (nonatomic, assign) BOOL showShopUser;

@end

@implementation UserContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loginView = [[UserProfileLoginView alloc] init];
    self.loginView.delegate = self;
    [self.view addSubview:self.loginView];
    [self.loginView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LYUser *currentUser = [LYUser currentUser];
    if (!currentUser) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self showLoginView:YES];
    } else {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self showLoginView:NO];
        if (currentUser.level == UserLevelShop) {
            self.showShopUser = YES;
        } else {
            self.showShopUser = NO;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark methods

- (void)showLoginView:(BOOL)show
{
    if (self.loginView.hidden == show) {
        self.loginView.hidden = !show;
        self.userVC.view.hidden = show;
        if (!show) {
            [self.userVC updateAvatar];
        }
    }
}

#pragma mark -
#pragma mark delegate

- (void)navigateToLoginPage
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    UINavigationController *loginViewNavigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginViewNavigationController animated:YES completion:nil];
}

#pragma mark -
#pragma mark accessor

- (void)setShowShopUser:(BOOL)showShopUser
{
    if (_showShopUser != showShopUser || !self.userVC) {
        _showShopUser = showShopUser;
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (showShopUser) {
            self.userVC = [sb instantiateViewControllerWithIdentifier:@"ShopUserViewController"];
            self.userVC.shopUser = YES;
        } else {
            self.userVC = [sb instantiateViewControllerWithIdentifier:@"NormalUserViewController"];
            self.userVC.shopUser = NO;
        }
        [self addChildViewController:self.userVC];
        [self.view addSubview:self.userVC.view];
    }
}

@end
