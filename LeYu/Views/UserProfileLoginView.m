//
//  UserProfileLoginView.m
//  LifeO2O
//
//  Created by jiecongwang on 7/4/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "UserProfileLoginView.h"
#import "ColorFactory.h"
#import "ImageFactory.h"

@interface UserProfileLoginView()

@property (nonatomic,strong) UILabel *loginDisplayText;

@property (nonatomic,strong) UIButton *loginButton;

@property (nonatomic,strong) UIImageView *backgroundImageView;

@end

@implementation UserProfileLoginView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundImageView = [[UIImageView alloc] init];
        self.backgroundImageView.image = [ImageFactory getImages:@"denglu"];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.backgroundImageView];
        
        self.loginDisplayText = [[UILabel alloc] init];
        self.loginDisplayText.numberOfLines =1;
        self.loginDisplayText.font = SystemFontWithSize(17);
        self.loginDisplayText.textColor = RGBCOLOR(212, 212, 212);
        self.loginDisplayText.textAlignment =  NSTextAlignmentCenter;
        self.loginDisplayText.text = @"请登录后查看";
        [self addSubview:self.loginDisplayText];
        
        self.loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [[self.loginButton layer] setBorderWidth:1.0f];
        [[self.loginButton layer] setBorderColor:DefaultYellowColor.CGColor];
        self.loginButton.layer.cornerRadius = 20;
        [self.loginButton.titleLabel setFont:SystemFontWithSize(18)];
        [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.loginButton];
        [self setupContraints];
    }
    return self;
}

- (void)setupContraints
{
    WeakSelf weakSelf =self;
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf).with.multipliedBy(0.7);
    }];
    
    [self.loginDisplayText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(self.backgroundImageView.mas_bottom).with.offset(40.0f);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.loginDisplayText.mas_bottom).with.offset(40.0f);
        make.width.equalTo(@(80.0f));
        make.height.equalTo(@(40.0f));
    }];
}

- (void)login
{
    if ([self.delegate respondsToSelector:@selector(navigateToLoginPage)]) {
        [self.delegate navigateToLoginPage];
    }
}

@end
