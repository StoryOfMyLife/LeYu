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

@property (nonatomic, assign) BOOL shopLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.loginButton.tintColor = [UIColor whiteColor];
    
    RAC(self.loginButton, enabled) = [RACSignal combineLatest:@[self.phone.rac_textSignal, self.password.rac_textSignal] reduce:(id)^(NSString *username, NSString *password){
        return @(username.length == 11 && password.length >= 6);
    }];
}

- (IBAction)login:(id)sender
{
    [LYUser logInWithMobilePhoneNumberInBackground:self.phone.text password:self.password.text block:^(AVUser *user, NSError *error) {
        LYUser *currentUser = [LYUser currentUser];
        AVQuery *query = [Shop query];
        [query whereKey:@"objectId" equalTo:currentUser.shop.objectId];
        Shop *shop = (Shop *)[query getFirstObject];
        currentUser.shop = shop;
        if (currentUser) {
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdelegate checkAddButton];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)shopLogin:(id)sender
{
    [self performSegueWithIdentifier:@"shopLogin" sender:@"shopLogin"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"shopLogin"]) {
        self.shopLogin = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
