//
//  UserNickNameEditViewController.m
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/9.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "UserNickNameEditViewController.h"
#import "ColorFactory.h"
#import <MBProgressHUD.h>
#import "LYUser.h"

@interface UserNickNameEditViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UITextField *textField;

@end

@implementation UserNickNameEditViewController

-(void)loadView {
    [super loadView];
    self.textField = [[UITextField alloc] init];
    self.textField.delegate =  self;
    self.textField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textField];
    WeakSelf weakSelf = self;
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(30.0f);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.equalTo(@(60.0f));
    }];
   
    

}

-(void)viewDidLoad {
    [super viewDidLoad];
    LYUser *user = [LYUser currentUser];
    if (user) {
        self.textField.text = user.username;
    };
}

-(void)updateUser {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    
    LYUser *user = [LYUser currentUser];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* string = [self.textField text];
    if (string) {
        user.username = string;
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
