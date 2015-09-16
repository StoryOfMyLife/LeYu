//
//  UserPersonalizedDiscriptionViewController.m
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/9.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "UserPersonalizedDiscriptionViewController.h"
#import "LYUser.h"
#import <MBProgressHUD.h>

@interface UserPersonalizedDiscriptionViewController ()

@property (nonatomic,strong) UITextView *textView;

@end

@implementation UserPersonalizedDiscriptionViewController

-(void)loadView {
    [super loadView];
    self.textView = [[UITextView alloc] init];
    self.textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    
    WeakSelf weakSelf = self;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).with.offset(30.0f);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.equalTo(@(150.0f));
    }];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    LYUser *user = [LYUser currentUser];
    if (user) {
        self.textView.text = user.personalDescription;
    }
}

-(void) updateUser {
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
    
    LYUser *user = [LYUser currentUser];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString* string = [self.textView text];
    if (string) {
        user.personalDescription = string;
    }
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (error) {
            //To do....
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
    
}

@end
