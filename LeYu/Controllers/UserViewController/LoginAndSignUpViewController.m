//
//  LoginViewController.m
//  LifeO2O
//
//  Created by jiecongwang on 6/30/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "LoginAndSignUpViewController.h"
#import "ColorFactory.h"
#import "SignUpViewController.h"
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

@property (nonatomic,strong) PhoneVerifiedLabel *phoneVerifiedLabel;

@property (nonatomic,strong) UIView* phoneVerifiedLabelSeparator;

@property (nonatomic,assign) BOOL verifyPhone;

@property (nonatomic,assign) BOOL successVerifyPhone;

@end

@implementation LoginAndSignUpViewController

-(instancetype)init {
    if (self = [super init]) {
        self.phoneNumberUtil = [[NBPhoneNumberUtil alloc] init];
        self.verifyPhone = NO;
        self.successVerifyPhone =NO;
    }
    return self;
}

-(instancetype)initWithMode:(BOOL)signUp{
    if (self = [super init]) {
        self.isSignUp = signUp;
        self.verifyPhone = NO;
        self.successVerifyPhone = NO;
        
    }
    return self;
};


-(void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    self.loginWrapperView = [[UIView alloc] init];
    self.loginWrapperView.backgroundColor = [ColorFactory dyLightGray];
    
    [self.view addSubview:self.loginWrapperView];
    
    self.prefix = [[UILabel alloc] init];
    self.prefix.numberOfLines =1;
    self.prefix.text = @"+86";
    self.prefix.textAlignment = NSTextAlignmentLeft;
    self.prefix.textColor = [UIColor grayColor];
    
    [self.loginWrapperView addSubview:self.prefix];
    
    self.phoneNumberTextField = [[LYUITextField alloc] initWithPlaceholder:@"电话号码"];
    [self.phoneNumberTextField setKeyboardType:UIKeyboardTypeNumberPad];

    [self.loginWrapperView addSubview:self.phoneNumberTextField];
    
    self.phoneVerifiedLabel = [[PhoneVerifiedLabel alloc] init];
    self.phoneVerifiedLabel.backgroundColor = [ColorFactory dyLightGray];
    self.phoneVerifiedLabel.delegate = self;
    [self.view addSubview:self.phoneVerifiedLabel];
    
    NSString *title = @"用手机登陆";
    if (self.isSignUp) {
        title = @"用手机注册";
    }
    
    self.loginButton = [[UIButton alloc] init];
    [[self.loginButton layer]setBorderWidth:1.0f];
    [[self.loginButton layer] setBorderColor:UIColorFromRGB(0xC4A24A).CGColor];
    [self.loginButton setTitle:title forState:UIControlStateNormal];
    [self.loginButton setTitleColor:UIColorFromRGB(0xC4A24A) forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
    
     [self.view addSubview:self.loginButton];
    
    self.signUpandSNSWrapperView  = [[UIView alloc] init];
    [self.view addSubview:self.signUpandSNSWrapperView];
    
    self.phoneVerifiedLabelSeparator = [[UIView alloc] init];
    self.phoneVerifiedLabelSeparator.backgroundColor = UIColorFromRGB(0xD3D3D3);
    [self.view addSubview:self.phoneVerifiedLabelSeparator];
    
    
    self.signUpButton =  [[UIButton alloc] init];
    [self.signUpButton setTitle:@"用户注册" forState:UIControlStateNormal];
    self.signUpButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.signUpButton.titleLabel.font = [UIFont fontWithName:@"Baskerville" size:14.0f];
    [self.signUpButton setTitleColor:UIColorFromRGB(0xC4A24A) forState:UIControlStateNormal];
    [self.signUpButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchDown];
    
    [self.signUpandSNSWrapperView addSubview:self.signUpButton];
    
    self.shopperLoginButton = [[UIButton alloc] init];
    [self.shopperLoginButton setTitle:@"店家登陆" forState:UIControlStateNormal];
    self.shopperLoginButton.titleLabel.font = [UIFont fontWithName:@"Baskerville" size:14.0f];
    [self.shopperLoginButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.shopperLoginButton addTarget:self action:@selector(shopperLoginUp) forControlEvents:UIControlEventTouchDown];
    [self.signUpandSNSWrapperView addSubview:self.shopperLoginButton];
    
    UIBarButtonItem *exitButtonItem = [[UIBarButtonItem alloc] initWithImage:[ImageFactory getScaleImages:@"btn_back_arrow_white"] style:UIBarButtonItemStylePlain target:self action:@selector(loginExit)];
    self.navigationItem.leftBarButtonItem = exitButtonItem;
    
    [self setupConstraints];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    if (self.isSignUp) {
        self.signUpandSNSWrapperView.hidden = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    AVUser *user = [AVUser currentUser];
    if (user) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }

}


-(void)setupConstraints{
    WeakSelf weakSelf =self;
    [self.loginWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).with.offset(30.0f);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.equalTo(@(50.0f));
    }];
    
    [self.prefix mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.loginWrapperView.mas_top);
        make.left.equalTo(weakSelf.loginWrapperView.mas_left).with.offset(10.0f);
        make.width.equalTo(weakSelf.loginWrapperView.mas_width).dividedBy(3);
        make.bottom.equalTo(weakSelf.loginWrapperView.mas_bottom);
    }];
    
    [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.prefix.mas_centerY);
        make.height.equalTo(weakSelf.prefix.mas_height);
        make.left.equalTo(weakSelf.prefix.mas_right);
        make.right.equalTo(weakSelf.loginWrapperView.mas_right);
    }];
    
    
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.loginWrapperView.mas_bottom).with.offset(30.0f);
        make.height.equalTo(@(40.0f));
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    [self.signUpandSNSWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.loginButton.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.signUpandSNSWrapperView.mas_top).with.offset(10.0f);
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

-(void)login{
    
    if (self.successVerifyPhone) {
        NSString *smsCode = [self.phoneVerifiedLabel.verifiedCodeField getText];
        NSError *error = nil;
        [LYUser signUpOrLoginWithMobilePhoneNumber:[self.phoneNumberTextField getText] smsCode:smsCode error:&error];
        if (!error) {
            LYUser *user = [LYUser currentUser];
            if (!user.hasBeenUpdate) {
                SignUpViewController *signUpViewController = [[SignUpViewController alloc] initWithUser:user];
                signUpViewController.delegate = self;
                [self.navigationController pushViewController:signUpViewController animated:YES];
            }else {
                [self loginCallback];
            }
            
        }else {
            [self.phoneVerifiedLabel.verifiedCodeField setError];
        }
        
        
        
    }else {
       [self verifyPhoneNumber];
    
    }
    

}


-(void) verifyPhoneNumber {

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
                        [UIView animateWithDuration:0.5
                                              delay:0
                                            options: UIViewAnimationOptionShowHideTransitionViews
                                         animations:^{
                                             WeakSelf weakSelf = self;
                                             [self.phoneVerifiedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                                                 make.top.equalTo(weakSelf.phoneVerifiedLabelSeparator.mas_bottom);
                                                 make.left.equalTo(weakSelf.view.mas_left);
                                                 make.right.equalTo(weakSelf.view.mas_right);
                                                 make.height.equalTo(@(50.0f));
                                             }];
                                             
                                             [self.phoneVerifiedLabelSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
                                                 make.top.equalTo(weakSelf.loginWrapperView.mas_bottom);
                                                 make.left.equalTo(weakSelf.view.mas_left).with.offset(10.0f);
                                                 make.right.equalTo(weakSelf.view.mas_right).with.offset(-10.0f);
                                                 make.height.equalTo(@(1.0f));
                                             }];
                                             
                                             
                                             [self.loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                                                 make.top.equalTo(weakSelf.phoneVerifiedLabel.mas_bottom).with.offset(30.0f);
                                                 make.height.equalTo(@(40.0f));
                                                 make.left.equalTo(weakSelf.view.mas_left);
                                                 make.right.equalTo(weakSelf.view.mas_right);
                                             }];
                                             
                                             [self.loginButton setTitle:@"验证并登陆" forState:UIControlStateNormal];
                                             [self.view layoutIfNeeded];
                                             
                                         }
                                         completion:^(BOOL finished){
                                             [self.phoneVerifiedLabel setTimeOut];
                                             self.verifyPhone = YES;
                                            
                                             [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         }];

                        
                    }else{
                        [self.phoneVerifiedLabel setTimeOut];
                       
                    }
                    
                    
                }else {
                   // to do show error
                
                }
                if (error) {
                    [self.phoneNumberTextField setError];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
                
            }];
            
            
        }else{
            [self.phoneNumberTextField setError];
           
        }
        
    }else {
        [self.phoneNumberTextField setError];
    }
    
}

-(void)shopperLoginUp{
   
}

-(void)signUp {
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



@end
