//
//  SignUpViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/18.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *smsCode;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)sendSMSCode:(id)sender
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
