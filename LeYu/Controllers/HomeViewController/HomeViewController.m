//
//  HomeViewController.m
//  LifeO2O
//
//  Created by jiecongwang on 5/28/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "HomeViewController.h"
#import "ShopActivityViewController.h"
#import "IntroViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) ShopActivityViewController *activityVC;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_leyu"]];
    [topImageView sizeToFit];
    self.navigationItem.titleView = topImageView;
    
    [self addChildViewController:self.activityVC];
    [self.view addSubview:self.activityVC.view];
    
    [self.activityVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    BOOL showedIntro = [[NSUserDefaults standardUserDefaults] boolForKey:@"intro"];
    if (!showedIntro) {
        IntroViewController *introVC = [[IntroViewController alloc] init];
        UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
        [rootVC.view addSubview:introVC.view];
        [rootVC addChildViewController:introVC];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (ShopActivityViewController *)activityVC
{
    if (!_activityVC) {
        _activityVC = [[ShopActivityViewController alloc] init];
        _activityVC.activityQuery = [ShopActivities query];
    }
    return _activityVC;
}

@end
