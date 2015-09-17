//
//  LoginViewController.m
//  LifeO2O
//
//  Created by jiecongwang on 6/30/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "LoginAndSignUpViewController.h"
#import "ColorFactory.h"
#import "SignUpViewController_old.h"
#import "ImageFactory.h"
#import "LYUITextField.h"
#import <NBPhoneNumberUtil.h>
#import <MBProgressHUD.h>
#import "PhoneVerifiedLabel.h"
#import "StringFactory.h"
#import "LYUser.h"
#import "UITabBarController+AddButton.h"

@interface LoginAndSignUpViewController () <PhoneVerifiedDelegate,UserLoginControllerDelegate>

@property (nonatomic,strong) UILabel *prefix;

@property (nonatomic,strong) UIView* loginWrapperView;

@property (nonatomic,strong) LYUITextField *phoneNumberTextField;

@property (nonatomic,strong) UIButton *loginButton;

@property (nonatomic,strong) UIButton *signUpButton;

@property (nonatomic,strong) UIButton *shopperLoginButton;

@property (nonatomic,strong) NBPhoneNumberUtil *phoneNumberUtil;

@property (nonatomic,strong) UIView *signUpandSNSWrapperView;

@property (nonatomic,assign) BOOL isSignUp;

@property (nonatomic,assign) BOOL isShopLogin;

@property (nonatomic,strong) PhoneVerifiedLabel *phoneVerifiedLabel;

@property (nonatomic,strong) UIView* phoneVerifiedLabelSeparator;

@property (nonatomic,assign) BOOL verifyPhone;

@property (nonatomic,assign) BOOL successVerifyPhone;

@end

@implementation LoginAndSignUpViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.phoneNumberUtil = [[NBPhoneNumberUtil alloc] init];
        self.verifyPhone = NO;
        self.successVerifyPhone =NO;
    }
    return self;
}

- (instancetype)initWithMode:(BOOL)signUp
{
    if (self = [self init]) {
        self.isSignUp = signUp;
    }
    return self;
};

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.loginWrapperView = [[UIView alloc] init];
    self.loginWrapperView.backgroundColor = [ColorFactory dyLightGray];
    
    [self.view addSubview:self.loginWrapperView];
    
    self.prefix = [[UILabel alloc] init];
    self.prefix.numberOfLines =1;
    self.prefix.text = @"手机号";
    self.prefix.textAlignment = NSTextAlignmentLeft;
    self.prefix.textColor = [UIColor grayColor];
    
    [self.loginWrapperView addSubview:self.prefix];
    
    self.phoneNumberTextField = [[LYUITextField alloc] initWithPlaceholder:@"请输入手机号"];
    [self.phoneNumberTextField setKeyboardType:UIKeyboardTypeNumberPad];

    [self.loginWrapperView addSubview:self.phoneNumberTextField];
    
    self.phoneVerifiedLabel = [[PhoneVerifiedLabel alloc] init];
    self.phoneVerifiedLabel.backgroundColor = [ColorFactory dyLightGray];
    self.phoneVerifiedLabel.delegate = self;
    [self.view addSubview:self.phoneVerifiedLabel];
    
    NSString *title = @"用户登录";
    if (self.isSignUp) {
        title = @"注册";
    } else if (self.isShopLogin) {
        title = @"店家登录";
    }
    self.title = title;
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.loginButton.backgroundColor = DefaultYellowColor;

    [self.loginButton setTitle:title forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
     [self.view addSubview:self.loginButton];
    
    self.signUpandSNSWrapperView  = [[UIView alloc] init];
    [self.view addSubview:self.signUpandSNSWrapperView];
    
    self.phoneVerifiedLabelSeparator = [[UIView alloc] init];
    self.phoneVerifiedLabelSeparator.backgroundColor = UIColorFromRGB(0xD3D3D3);
    [self.view addSubview:self.phoneVerifiedLabelSeparator];
    
    self.signUpButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.signUpButton setTitle:@"用户注册" forState:UIControlStateNormal];
    self.signUpButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.signUpButton.titleLabel.font = [UIFont fontWithName:@"Baskerville" size:14.0f];
    [self.signUpButton setTitleColor:DefaultYellowColor forState:UIControlStateNormal];
    [self.signUpButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    
    [self.signUpandSNSWrapperView addSubview:self.signUpButton];
    
    self.shopperLoginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.shopperLoginButton setTitle:@"店家登录" forState:UIControlStateNormal];
    self.shopperLoginButton.titleLabel.font = [UIFont fontWithName:@"Baskerville" size:14.0f];
    [self.shopperLoginButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.shopperLoginButton addTarget:self action:@selector(shopperLoginUp) forControlEvents:UIControlEventTouchUpInside];
    [self.signUpandSNSWrapperView addSubview:self.shopperLoginButton];
    
    UIBarButtonItem *exitButtonItem = [[UIBarButtonItem alloc] initWithImage:[ImageFactory getScaleImages:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(loginExit)];
    self.navigationItem.leftBarButtonItem = exitButtonItem;
    
    [self setupConstraints];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.isSignUp) {
        self.signUpandSNSWrapperView.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    AVUser *user = [AVUser currentUser];
    if (user) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setupConstraints
{
    WeakSelf weakSelf =self;
    [self.loginWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).with.offset(30.0f);
        make.left.right.equalTo(weakSelf.view);
        make.height.equalTo(@(50.0f));
    }];
    
    [self.prefix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.loginWrapperView);
        make.left.equalTo(weakSelf.loginWrapperView).offset(10.0f);
        make.bottom.equalTo(weakSelf.loginWrapperView);
    }];
    
    [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.prefix);
        make.height.equalTo(weakSelf.prefix);
        make.left.equalTo(weakSelf.prefix.mas_right).offset(10);
        make.right.equalTo(weakSelf.loginWrapperView);
    }];
    
    [self.phoneVerifiedLabelSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.loginWrapperView.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    [self.phoneVerifiedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.phoneVerifiedLabelSeparator);
        make.top.equalTo(self.phoneVerifiedLabelSeparator.mas_bottom);
        make.height.mas_equalTo(0);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.self.phoneVerifiedLabel.mas_bottom).with.offset(30.0f);
        make.height.equalTo(@(50.0f));
        make.left.right.equalTo(weakSelf.view);
    }];
    
    [self.signUpandSNSWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.loginButton.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.signUpandSNSWrapperView.mas_top).with.offset(20.0f);
        make.height.equalTo(@(20.0f));
        make.left.equalTo(weakSelf.view.mas_left);
        make.width.equalTo(weakSelf.view.mas_width).dividedBy(4);
    }];
    
    [self.shopperLoginButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.signUpButton.mas_centerY);
        make.right.equalTo(weakSelf.view.mas_right);
        make.width.equalTo(weakSelf.view.mas_width).dividedBy(4);
        make.height.equalTo(@(20.0f));
    }];
}

- (void)login
{
    if (self.successVerifyPhone) {
        NSString *smsCode = [self.phoneVerifiedLabel.verifiedCodeField getText];
        NSError *error = nil;
        [LYUser signUpOrLoginWithMobilePhoneNumber:[self.phoneNumberTextField getText] smsCode:smsCode error:&error];
        if (!error) {
            LYUser *user = [LYUser currentUser];
            if (self.isShopLogin) {
                //TODO:
            }
            if (!user.hasBeenUpdate) {
                SignUpViewController_old *signUpViewController = [[SignUpViewController_old alloc] initWithUser:user];
                signUpViewController.delegate = self;
                [self.navigationController pushViewController:signUpViewController animated:YES];
            } else {
                [self loginCallback];
            }
        } else {
            [self.phoneVerifiedLabel.verifiedCodeField setError];
        }
    } else {
       [self verifyPhoneNumber];
    }
}

- (void)verifyPhoneNumber
{
    if (![self.phoneNumberTextField textContentNotEmpty]) {
        return;
    }
    
    [self.phoneNumberTextField resignResponder];
    
    NSError *error =nil;
    NBPhoneNumber *phoneNumber = [self.phoneNumberUtil parse:[self.phoneNumberTextField getText] defaultRegion:@"CN" error:&error];
    if (!error) {
        BOOL isValid = [self.phoneNumberUtil isValidNumber:phoneNumber];
        if (isValid) {
            MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            [AVOSCloud requestSmsCodeWithPhoneNumber: [self.phoneNumberTextField getText] callback:^(BOOL isSuccess, NSError *error) {
                
                if (isSuccess) {
                    self.successVerifyPhone  =YES;
                    self.phoneNumberTextField.shouldBeginTextEditingHandler = ^BOOL(UITextField *textFiled) {
                        return NO;
                    };
                  
                    if (!self.verifyPhone) {
                        
                        [self.phoneVerifiedLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.equalTo(@(50.0f));
                        }];
                        
                        [self.phoneVerifiedLabelSeparator mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.equalTo(@(1.0f));
                        }];
                        
                        [UIView animateWithDuration:0.5
                                              delay:0
                                            options:UIViewAnimationOptionCurveEaseInOut
                                         animations:^{
                                             [self.loginButton setTitle:@"验证并登陆" forState:UIControlStateNormal];
                                             [self.view layoutIfNeeded];
                                             self.phoneVerifiedLabel.countingLabel.alpha = 1;
                                         }
                                         completion:^(BOOL finished){
                                             [self.phoneVerifiedLabel setTimeOut];
                                             self.verifyPhone = YES;
                                            
                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         }];
                    } else {
                        [self.phoneVerifiedLabel setTimeOut];
                    }
                } else {
                   // to do show error
                }
                if (error) {
                    [self.phoneNumberTextField setError];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }];
        } else {
            [self.phoneNumberTextField setError];
        }
    } else {
        [self.phoneNumberTextField setError];
    }
}

- (void)shopperLoginUp
{
    LoginAndSignUpViewController *signUpController = [[LoginAndSignUpViewController alloc] initWithMode:NO];
    signUpController.isShopLogin = YES;
    signUpController.delegate = self;
    [self.navigationController pushViewController:signUpController animated:YES];
}

- (void)signUp
{
    LoginAndSignUpViewController *signUpController = [[LoginAndSignUpViewController alloc] initWithMode:YES];
    signUpController.delegate = self;
    [self.navigationController pushViewController:signUpController animated:YES];
}

-(void)loginExit{
    if (self.delegate && [self.delegate respondsToSelector:@selector(exitLoginProcess)]) {
        [self.delegate exitLoginProcess];
    }
}

-(void)exitLoginProcess {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) addAddButtonForShopOwner {
    LYUser *currentUser = [LYUser currentUser];
    UITabBarController *tabBarController = (UITabBarController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    if (currentUser.shop) {
        [tabBarController showAddButton];
        
    }else {
        [tabBarController hideAddButton];
    }
}

-(void)loginCallback {
    [self addAddButtonForShopOwner];
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginCallback)]) {
        [self.delegate loginCallback];
    }
}

-(void)resentCode {
    [self verifyPhoneNumber];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
