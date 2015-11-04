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

@interface HomeViewController () <LTableViewScrollDelegate>

@property (nonatomic, strong) ShopActivityViewController *activityVC;
@property (nonatomic, strong) UIImageView *topImageView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top_leyu"]];
    self.navigationItem.titleView = self.topImageView;
    
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

- (void)LTableViewDidScroll:(UIScrollView *)tableView
{
    CGFloat offsetY = tableView.contentOffset.y;
    if (offsetY <= 0) {
        CGRect frame = self.topImageView.frame;
        frame.origin.y = -offsetY + 5;
        self.topImageView.frame = frame;
        self.topImageView.alpha = 1 + offsetY / 20;
    } else {
        offsetY = 0;
        CGRect frame = self.topImageView.frame;
        frame.origin.y = -offsetY + 5;
        self.topImageView.frame = frame;
        self.topImageView.alpha = 1 + offsetY / 20;
    }
}

- (ShopActivityViewController *)activityVC
{
    if (!_activityVC) {
        _activityVC = [[ShopActivityViewController alloc] init];
        _activityVC.delegate = self;
        AVQuery *query = [ShopActivities query];
        _activityVC.activityQuery = query;
    }
    return _activityVC;
}

@end
