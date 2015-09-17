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

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.phone.tintColor = DefaultYellowColor;
    self.password.tintColor = DefaultYellowColor;
    
    
}

- (IBAction)login:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

@end
