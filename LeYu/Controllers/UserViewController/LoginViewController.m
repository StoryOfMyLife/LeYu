//
//  LoginViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/17.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.phone.tintColor = DefaultYellowColor;
    self.password.tintColor = DefaultYellowColor;
    
    RAC(self.loginButton, enabled) = [RACSignal combineLatest:@[self.phone.rac_textSignal, self.password.rac_textSignal] reduce:(id)^(NSString *username, NSString *password){
        return @(username.length == 11 && password.length >= 6);
    }];
}

- (IBAction)login:(id)sender
{
    [AVUser logInWithMobilePhoneNumberInBackground:self.phone.text password:self.password.text block:^(AVUser *user, NSError *error) {
        if (user) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
