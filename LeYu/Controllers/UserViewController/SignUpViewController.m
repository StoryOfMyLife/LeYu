//
//  SignUpViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/18.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "SignUpViewController.h"
#import <NBPhoneNumberUtil.h>
#import <UICountingLabel.h>

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *smsCode;

@property (nonatomic, strong) NBPhoneNumberUtil *phoneNumberUtil;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *sendSMSButton;
@property (weak, nonatomic) IBOutlet UICountingLabel *countingLabel;

@property (nonatomic, assign) BOOL smsCodeSended;
@property (nonatomic, assign) BOOL verified;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneNumberUtil = [[NBPhoneNumberUtil alloc] init];
    
    self.smsCodeSended = NO;
    self.verified = NO;
    
    self.countingLabel.textColor = DefaultYellowColor;
    self.countingLabel.textAlignment = NSTextAlignmentCenter;
    self.countingLabel.format = @"%d";
    self.countingLabel.method = UILabelCountingMethodLinear;
    
    weakSelf();
    self.countingLabel.completionBlock = ^{
        weakSelf.smsCodeSended = NO;
    };
    
    RAC(self.sendSMSButton, enabled) = [self.phone.rac_textSignal map:^id(NSString *text) {
        return @(text.length == 11);
    }];
    
    RAC(self.countingLabel, hidden) = [RACObserve(self, smsCodeSended) map:^id(NSNumber *x) {
        return @(!x.boolValue);
    }];
    
    RAC(self.sendSMSButton, hidden) = RACObserve(self, smsCodeSended);
    
    RAC(self.nextButton, enabled) = [RACSignal combineLatest:@[self.phone.rac_textSignal, self.smsCode.rac_textSignal] reduce:(id)^(NSString *username, NSString *password){
        return @(username.length == 11 && password.length == 6);
    }];
    
    RAC(self, verified) = [RACSignal combineLatest:@[self.phone.rac_textSignal, self.smsCode.rac_textSignal] reduce:(id)^(NSString *username, NSString *password){
        return @(NO);
    }];
}

- (IBAction)sendSMSCode:(id)sender
{
    NSError *error =nil;
    NBPhoneNumber *phoneNumber = [self.phoneNumberUtil parse:self.phone.text defaultRegion:@"CN" error:&error];
    if (!error) {
        BOOL isValid = [self.phoneNumberUtil isValidNumber:phoneNumber];
        if (isValid) {
            [AVOSCloud requestSmsCodeWithPhoneNumber:self.phone.text callback:^(BOOL isSuccess, NSError *error) {
                if (isSuccess) {
                    self.smsCodeSended = YES;
                    [self.countingLabel countFrom:59 to:0 withDuration:60];
                }
            }];
        } else {
            Log(@"phone invalid");
        }
    }
}

- (IBAction)next:(id)sender
{
    if (self.verified) {
        [self performSegueWithIdentifier:@"next" sender:@{@"smsCode" : self.smsCode.text, @"phone" : self.phone.text}];
    }
    [AVOSCloud verifySmsCode:self.smsCode.text mobilePhoneNumber:self.phone.text callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            self.verified = YES;
            [self performSegueWithIdentifier:@"next" sender:@{@"smsCode" : self.smsCode.text, @"phone" : self.phone.text}];
        } else {
            Log(@"sms code invalid");
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
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
