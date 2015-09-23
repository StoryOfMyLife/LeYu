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

@property (nonatomic, strong) NoDataViewController *noDataVC;

@end

@implementation LViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hideNoData];
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
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (NoDataViewController *)noDataVC
{
    if (!_noDataVC) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _noDataVC = [sb instantiateViewControllerWithIdentifier:@"NoDataViewController"];
        _noDataVC.info = @"没有消息";
        [self.view addSubview:_noDataVC.view];
        [self addChildViewController:_noDataVC];
    }
    return _noDataVC;
}

- (void)showNoData:(NSString *)noDateInfo
{
    self.noDataVC.view.hidden = NO;
    self.noDataVC.info = noDateInfo;
    [self.view bringSubviewToFront:self.noDataVC.view];
}

- (void)hideNoData
{
    self.noDataVC.view.hidden = YES;
}

@end
