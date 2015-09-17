//
//  ForgetPasswordViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/18.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import <NBPhoneNumberUtil.h>
#import <UICountingLabel.h>

@interface ForgetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *smsCode;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *sendSMSButton;
@property (weak, nonatomic) IBOutlet UICountingLabel *countingLabel;

@property (nonatomic, strong) NBPhoneNumberUtil *phoneNumberUtil;

@property (nonatomic, assign) BOOL smsCodeSended;
@property (nonatomic, assign) BOOL verified;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneNumberUtil = [[NBPhoneNumberUtil alloc] init];
    self.smsCodeSended = NO;
    self.verified = NO;
    
    self.countingLabel.textColor = DefaultYellowColor;
    self.countingLabel.textAlignment = NSTextAlignmentCenter;
    self.countingLabel.format = @"%d";
    self.countingLabel.method = UILabelCountingMethodLinear;
    
    RAC(self.countingLabel, hidden) = [RACObserve(self, smsCodeSended) map:^id(NSNumber *x) {
        return @(!x.boolValue);
    }];
    
    RAC(self.sendSMSButton, hidden) = RACObserve(self, smsCodeSended);
    
    RAC(self.sendSMSButton, enabled) = [self.phone.rac_textSignal map:^id(NSString *text) {
        return @(text.length == 11);
    }];
    
    RAC(self.confirmButton, enabled) = [RACSignal combineLatest:@[self.phone.rac_textSignal, self.smsCode.rac_textSignal, self.password.rac_textSignal] reduce:(id)^(NSString *phone, NSString *smsCode, NSString *password){
        return @(phone.length == 11 && password.length >= 6 && smsCode.length == 6);
    }];
}

- (IBAction)sendSMSCode:(id)sender
{
    NSError *error =nil;
    NBPhoneNumber *phoneNumber = [self.phoneNumberUtil parse:self.phone.text defaultRegion:@"CN" error:&error];
    if (!error) {
        BOOL isValid = [self.phoneNumberUtil isValidNumber:phoneNumber];
        if (isValid) {
            [AVUser requestPasswordResetWithPhoneNumber:self.phone.text block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    self.smsCodeSended = YES;
                    [self.countingLabel countFrom:59 to:0 withDuration:60];
                } else {
                    Log(@"手机重置密码，验证码失败");
                }
            }];
        } else {
            Log(@"phone invalid");
        }
    }
}

- (IBAction)confirm:(id)sender
{
    [AVUser resetPasswordWithSmsCode:self.smsCode.text newPassword:self.password.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            Log(@"密码重置成功");
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            Log(@"密码重置失败");
        }
    }];
}

@end
