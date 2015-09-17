//
//  UserProfileViewController.m
//  LifeO2O
//
//  Created by jiecongwang on 5/28/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserProfileLoginView.h"
#import "LoginAndSignUpViewController.h"
#import "UserProfileInfoCell.h"
#import "UserLikeAndSettingCell.h"
#import "ColorFactory.h"
#import "LYUser.h"
#import "UserInfoDetailViewController.h"
#import "UserFavoriteShopsViewController.h"
#import "UserSettingsViewController.h"

#import "LoginViewController.h"

@interface UserProfileViewController () <UserLoginControllerDelegate,UserProfileLoginDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UserProfileLoginView *loginView;

@property (nonatomic, strong) UIView *userInfoFooterView;

@property (nonatomic, assign) CGFloat userInfoHeight;;

@end

@implementation UserProfileViewController

- (UIView *)tableHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    return headerView;
}

- (void)showLoginView
{
    self.tableView.hidden = YES;
    [self.view addSubview:self.loginView];
    WeakSelf weakself =self;
    [self.loginView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.view);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.loginView = [[UserProfileLoginView alloc] init];
    self.loginView.delegate =self;
    self.userInfoFooterView = [[UIView alloc] init];
    self.userInfoFooterView.backgroundColor = UIColorFromRGB(0xeeeeee);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.tableHeaderView = [self tableHeaderView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView= [[UIView alloc]init];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self registerTableCells];
    
    self.title = @"个人";
}

- (void)registerTableCells
{
    [self.tableView registerClass:UserProfileInfoCell.class forCellReuseIdentifier:NSStringFromClass(UserProfileInfoCell.class)];
    [self.tableView registerClass:UserLikeAndSettingCell.class forCellReuseIdentifier:NSStringFromClass(UserLikeAndSettingCell.class)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    LYUser *currentUser = (LYUser *)[LYUser currentUser];
    if (!currentUser) {
        [self showLoginView];
    }
    
    if (currentUser && [self.loginView isDescendantOfView:self.view]) {
        self.tableView.hidden = NO;
         [self.loginView removeFromSuperview];
    }
    
    UserProfileInfoCell * dummyCell = [[UserProfileInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dummyCell"];
    [dummyCell configureUser:currentUser];
    self.userInfoHeight = [dummyCell.userInfoWrapperView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
    [self.tableView reloadData];

}

- (void)navigateToLoginPage
{
//    LoginAndSignUpViewController *loginViewController = [[LoginAndSignUpViewController alloc] init];
//    loginViewController.delegate =  self;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    UINavigationController *loginViewNavigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:loginViewNavigationController animated:YES completion:nil];
}

#pragma mark -
#pragma mark UserLoginControllerDelegate

- (void)exitLoginProcess
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginCallback
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case UserProfileInfoCellSection:
            return 1;
        case UserLikeAndSettingCellSection:
            return 2;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case UserLikeAndSettingCellSection:
            return 50.0f;
            
        case UserProfileInfoCellSection:{
            if(self.userInfoHeight+60.0f > 140) {
                return self.userInfoHeight + 60.0f;
            }else {
                return 140.0f;
            }
        }
    }
    return 0.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return UserProfileViewSectionCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case UserProfileInfoCellSection:{
            UserProfileInfoCell *profileCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UserProfileInfoCell.class) forIndexPath:indexPath];
            [profileCell configureUser:[LYUser currentUser]];
            return profileCell;
        }
        case UserLikeAndSettingCellSection: {
            UserLikeAndSettingCell *likeAndSettingCell = [tableView dequeueReusableCellWithIdentifier:
                                                                 NSStringFromClass(UserLikeAndSettingCell.class) forIndexPath:indexPath];
            switch (indexPath.row) {
                case Like:
                    likeAndSettingCell.textLabel.text =@"我的收藏";
                    likeAndSettingCell.imageView.image = [UIImage imageNamed:@"Collection"];
                    break;
                    
                case Setting:
                    likeAndSettingCell.textLabel.text =@"设定";
                    likeAndSettingCell.imageView.image = [UIImage imageNamed:@"Setup"];
                    break;
            }
            likeAndSettingCell.textLabel.font = [UIFont fontWithName:@"Baskerville" size:18.0f];
            likeAndSettingCell.textLabel.textColor = UIColorFromRGB(0x000000);
            likeAndSettingCell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
            
            return likeAndSettingCell;
        }
       
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case UserLikeAndSettingCellSection:
            return 0.0f;
        case UserProfileInfoCellSection:
            return 25.0f;
            
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    switch (section) {
        case UserProfileInfoCellSection: {
            return self.userInfoFooterView;
        }
    }
    return nil;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case UserProfileInfoCellSection:{
            UserInfoDetailViewController *detailViewController = [[UserInfoDetailViewController alloc] initWithUser:[LYUser currentUser]];
            [self.navigationController pushViewController:detailViewController animated:YES];
            break;
         }
        case UserLikeAndSettingCellSection: {
            if (indexPath.row == 0) {
                UserFavoriteShopsViewController *favoriteShopViewController = [[UserFavoriteShopsViewController alloc] initWithUser:[LYUser currentUser]];
                [self.navigationController pushViewController:favoriteShopViewController animated:YES];
            }
            
            if (indexPath.row == 1) {
                UserSettingsViewController *settingViewController = [[UserSettingsViewController alloc] initWithUser:[LYUser currentUser]];
                [self.navigationController pushViewController:settingViewController animated:YES];
            }
        
        }
            
    
    }

}




@end
