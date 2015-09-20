//
//  SignUpMoreViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/18.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "SignUpMoreViewController.h"

@interface SignUpMoreViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (nonatomic, strong) NSDictionary *userInfo;

@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@end

@implementation SignUpMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.signUpButton, enabled) = [RACSignal combineLatest:@[self.name.rac_textSignal, self.password.rac_textSignal] reduce:(id)^(NSString *username, NSString *password){
        return @(username.length > 0 && password.length >= 6);
    }];
}

- (IBAction)signUp:(id)sender
{
    LYUser *user = [LYUser user];
    user.username = self.name.text;
    user.password = self.password.text;
    user.mobilePhoneNumber = self.userInfo[@"phone"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //注册成功，登录
            [LYUser logInWithMobilePhoneNumberInBackground:self.userInfo[@"phone"] password:self.password.text block:^(AVUser *user, NSError *error) {
                if (user) {
                    [self dismiss];
                }
            }];
        } else {
            Log(@"注册失败");
        }
    }];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.userInfo = sender;
}

@end
