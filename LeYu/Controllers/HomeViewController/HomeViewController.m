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
#import "HFCreateAvtivityViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"

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
    
    [self checkAddButton];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAddButton) name:kUserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAddButton) name: kUserDidLogoutNotification object:nil];
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

- (void)checkAddButton
{
    LYUser *currentUser = [LYUser currentUser];
    if (currentUser) {
        if (currentUser.shop) {
            AVQuery *query = [Shop query];
            [query whereKey:@"objectId" equalTo:currentUser.shop.objectId];
            Shop *shop = (Shop *)[query getFirstObject];
            currentUser.shop = shop;
        } else {
            currentUser.level = UserLevelNormal;
        }
        [currentUser saveInBackground];
        
        if (currentUser.level == UserLevelShop) {
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
            rightButton.tintColor = [UIColor whiteColor];
            [rightButton addTarget:self action:@selector(createActivity) forControlEvents:UIControlEventTouchUpInside];
            [rightButton setTitle:@"发布" forState:UIControlStateNormal];
            [rightButton sizeToFit];
            UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
            self.navigationItem.rightBarButtonItem = rightBarItem;
        }
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)createActivity
{
    HFCreateAvtivityViewController *picker = [[HFCreateAvtivityViewController alloc] init];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)LTableViewDidScroll:(UIScrollView *)tableView
{
    CGFloat offsetY = tableView.contentOffset.y;
    if (offsetY <= 0) {
        CGRect frame = self.topImageView.frame;
        frame.origin.y = -offsetY + 5;
        self.topImageView.frame = frame;
        self.topImageView.alpha = 1 + offsetY / 50;
    } else {
        offsetY = 0;
        CGRect frame = self.topImageView.frame;
        frame.origin.y = -offsetY + 5;
        self.topImageView.frame = frame;
        self.topImageView.alpha = 1;
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
