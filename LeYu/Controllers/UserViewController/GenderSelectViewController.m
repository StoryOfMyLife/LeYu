//
//  GenderSelectViewController.m
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/9.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "GenderSelectViewController.h"
#import "ColorFactory.h"
#import "LYUser.h"
#import <MBProgressHUD.h>

@interface GenderSelectViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) NSUInteger gender;

@end

@implementation GenderSelectViewController

-(void)loadView {
    [super loadView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [ColorFactory dyLightGray];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    WeakSelf weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
};


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
};

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"genderCell"];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * genderCell = [tableView dequeueReusableCellWithIdentifier:@"genderCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        genderCell.textLabel.text = @"男";
    }else {
        genderCell.textLabel.text = @"女";
    }
    genderCell.accessoryType = UITableViewCellAccessoryCheckmark;
    return genderCell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.gender = indexPath.row;
}

-(void)updateUser{
    LYUser *user = [LYUser currentUser];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.gender == 0) {
        user.sex = @"男";
    }else {
        user.sex = @"女";
    }
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (error) {
            //To do....
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    

}



@end
