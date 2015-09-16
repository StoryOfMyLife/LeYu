//
//  SignUpViewController.m
//  LifeO2O
//
//  Created by jiecongwang on 7/4/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "SignUpViewController.h"
#import "LYUITextField.h"
#import "ColorFactory.h"
#import <MBProgressHUD.h>
#import "StringFactory.h"


@interface SignUpViewController ()


@property (nonatomic,strong) LYUITextField *usernameTextField;

@property (nonatomic,strong) LYUITextField *passwordTextField;

@property (nonatomic,strong) LYUITextField *passwordAgainTextField;


@property (nonatomic,strong) UIView* usernameSeparator;

@property (nonatomic,strong) UIView* passwordSeparator;

@property (nonatomic,strong) UIView* passwordAgainSeparator;

@property (nonatomic,strong) UIView* userEditWrapperView;

@property (nonatomic,strong) UIButton* signUpButton;

@property (nonatomic,strong) LYUser *user;

@end

@implementation SignUpViewController


-(instancetype) initWithUser:(LYUser *)user {
    if (self = [self init]) {
        self.user = user;
    }
    return self;
}


-(void)loadView{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.userEditWrapperView = [[UIView alloc] init];
    self.userEditWrapperView.backgroundColor = UIColorFromRGB(0xF7F7F7);
    [self.view addSubview:self.userEditWrapperView];
    
    
    self.usernameTextField = [[LYUITextField alloc] initWithPlaceholder:@"请输入用户名" WithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    [self.usernameTextField setKeyboardType:UIKeyboardTypeDefault];
  
    [self.userEditWrapperView addSubview:self.usernameTextField];
    
    self.usernameSeparator = [[UIView alloc] init];
    self.usernameSeparator.backgroundColor = [ColorFactory dyLightGray];
    [self.userEditWrapperView addSubview:self.usernameSeparator];
    
    
    self.passwordTextField = [[LYUITextField alloc] initWithPlaceholder:@"请输入密码" WithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    [self.passwordTextField typeAsPassword];
   
    [self.userEditWrapperView addSubview:self.passwordTextField];
    
    self.passwordSeparator = [[UIView alloc] init];
    self.passwordSeparator.backgroundColor = [ColorFactory dyLightGray];
    [self.userEditWrapperView addSubview:self.passwordSeparator];
    
    self.passwordAgainTextField = [[LYUITextField alloc] initWithPlaceholder:@"请再次输入密码" WithEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
    [self.passwordAgainTextField typeAsPassword];
    
    [self.userEditWrapperView addSubview:self.passwordAgainTextField];
    
    self.signUpButton = [[UIButton alloc] init];
    [[self.signUpButton layer]setBorderWidth:1.0f];
    [[self.signUpButton layer] setBorderColor:UIColorFromRGB(0xC4A24A).CGColor];
    [self.signUpButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.signUpButton setTitleColor:UIColorFromRGB(0xC4A24A) forState:UIControlStateNormal];
    [self.signUpButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchDown];
    
    
    [self.view addSubview:self.signUpButton];
    
    [self setupConstraints];
    
}


-(void)setupConstraints{
    WeakSelf weakSelf =self;
    [self.userEditWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(30.0f);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.equalTo(@(136.0f));
    }];
    
    
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.userEditWrapperView.mas_top);
        make.left.equalTo(weakSelf.userEditWrapperView.mas_left);
        make.right.equalTo(weakSelf.userEditWrapperView.mas_right);
        make.height.equalTo(@(45.0f));
    }];
    
    [self.usernameSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.usernameTextField.mas_bottom);
        make.left.equalTo(weakSelf.userEditWrapperView.mas_left).with.offset(15.0f);
        make.right.equalTo(weakSelf.userEditWrapperView.mas_right).with.offset(15.0f);
        make.height.equalTo(@(1.0f));
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.usernameSeparator.mas_bottom);
        make.left.equalTo(weakSelf.userEditWrapperView.mas_left);
        make.right.equalTo(weakSelf.userEditWrapperView.mas_right);
        make.height.equalTo(@(45.0f));
    }];
    
    [self.passwordSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.passwordTextField.mas_bottom);
        make.left.equalTo(weakSelf.userEditWrapperView.mas_left).with.offset(15.0f);
        make.right.equalTo(weakSelf.userEditWrapperView.mas_right).with.offset(15.0f);
        make.height.equalTo(@(1.0f));
    }];
    
    [self.passwordAgainTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.passwordSeparator.mas_bottom);
        make.left.equalTo(weakSelf.userEditWrapperView.mas_left);
        make.right.equalTo(weakSelf.userEditWrapperView.mas_right);
        make.bottom.equalTo(weakSelf.userEditWrapperView.mas_bottom);
    }];
    
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.userEditWrapperView.mas_bottom).with.offset(30.0f);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.equalTo(@(40.0f));
    }];
    
}

-(void)signUp{
    
    if ([self validateForm]) {
        self.user.username = [self.usernameTextField getText];
        self.user.password = [self.passwordTextField getText];
        self.user.hasBeenUpdate = YES;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        [self.user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [hud hide:YES];
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(loginCallback)]) {
                    [self.delegate loginCallback];
                }
            }
            if (error) {
                [hud hide:YES];
            }
            
        }];
        
    }



}

-(BOOL) validateForm{
   
    
    if (![self.usernameTextField textContentNotEmpty]) {
        return NO;
    }
    
    if (![self.passwordTextField textContentNotEmpty]) {
        return NO;
    }
    if (![self.passwordAgainTextField textContentNotEmpty]) {
        return NO;
    }
    
 
    if (![[self.passwordAgainTextField getText] isEqualToString:[self.passwordTextField getText]]) {
        [self.passwordAgainTextField setError];
        return NO;
    }
  
    if ([self.usernameTextField isResponder]) {
        [self.usernameTextField resignResponder];
    }
    
    if ([self.passwordAgainTextField isResponder]) {
        [self.passwordAgainTextField resignResponder];
    }
    
    if ([self.passwordTextField isResponder]) {
        [self.passwordTextField resignResponder];
    }
    
    return YES;
}

-(BOOL)validateEmail:(NSString *)emails {
    NSString *emailid = emails;
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:emailid];
    return myStringMatchesRegEx;
};



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




@end
