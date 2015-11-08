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
                if (!error) {
                    LYUser *currentUser = [LYUser currentUser];
                    if (currentUser) {
                        AVQuery *query = [Shop query];
                        [query whereKey:@"objectId" equalTo:currentUser.shop.objectId];
                        Shop *shop = (Shop *)[query getFirstObject];
                        currentUser.shop = shop;
                        
                        [self dismiss];
                    }
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"登录失败:%@", error.userInfo[@"NSLocalizedDescription"]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                }
            }];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"注册失败:%@", error.userInfo[@"NSLocalizedDescription"]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
