//
//  UserSettingsViewController.m
//  LifeO2O
//
//  Created by jiecongwang on 7/24/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "UserSettingsViewController.h"
#import "ColorFactory.h"

@interface UserSettingsViewController() <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) LYUser *user;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation UserSettingsViewController


-(instancetype) initWithUser:(LYUser *)user {
    if (self = [self init]) {
        self.user =user;
    }
    return self;
}

-(void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    WeakSelf weakSelf =self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    self.tableView.tableFooterView = [self loadFooterView];
    self.title = @"设置";
}


-(UIView *)loadFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width,50.0f)];
    UIButton *logoutButton = [[UIButton alloc] init];
    logoutButton.backgroundColor = UIColorFromRGB(0xe0e0e0);
    [logoutButton setTitle:@"退出" forState:UIControlStateNormal];
     logoutButton.titleLabel.textColor = UIColorFromRGB(0x969696);
    [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchDown];
    [footerView addSubview:logoutButton];
    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top);
        make.left.equalTo(footerView.mas_left);
        make.right.equalTo(footerView.mas_right);
        make.bottom.equalTo(footerView.mas_bottom);
    }];
    
    return footerView;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case UserGeneralSetting: {
            switch (indexPath.row) {
                case Notification: {
                    tableViewCell.textLabel.text = @"通知";
                    break;
                }
                case Privacy: {
                   tableViewCell.textLabel.text = @"隐私";
                    break;
                }
                case General: {
                    tableViewCell.textLabel.text = @"通用";
                    break;
                }
                    
            }
            break;

        }
        case AboutUs: {
            tableViewCell.textLabel.text = @"关于我们";
            break;
        
        }
    }
    
    return tableViewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case UserGeneralSetting:
            return 3;
        case AboutUs:
            return 1;
            
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return UserSettingSectionCount;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == AboutUs) {
        return 20.0f;
    }
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == AboutUs) {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [ColorFactory dyLightGray];
        return footerView;
    }
    return nil;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [ColorFactory dyLightGray];
    return footerView;
}

-(void)logout {
    [LYUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}






@end
