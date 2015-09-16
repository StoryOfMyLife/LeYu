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


-(instancetype)init {

    if (self = [super init]) {
        self.backgroundImageView = [[UIImageView alloc] init];
        self.backgroundImageView.image = [ImageFactory getImages:@"denglu"];
        self.backgroundImageView.clipsToBounds = YES;
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.backgroundImageView];
        
        self.loginDisplayText = [[UILabel alloc] init];
        self.loginDisplayText.numberOfLines =1;
        self.loginDisplayText.font = [UIFont fontWithName:@"System" size:26.0f];
        self.loginDisplayText.textColor = UIColorFromRGB(0xB4B4B4);
        self.loginDisplayText.textAlignment =  NSTextAlignmentCenter;
        self.loginDisplayText.text = @"请登陆后查看";
        [self addSubview:self.loginDisplayText];
        
        self.loginButton = [[UIButton alloc] init];
        [[self.loginButton layer] setBorderWidth:1.0f];
        [[self.loginButton layer] setBorderColor:UIColorFromRGB(0xC4A24A).CGColor];
        [self.loginButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.loginButton.titleLabel setFont:[UIFont fontWithName:@"System" size:28.0f]];
        [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.loginButton];
        [self setupContraints];
    }
    return self;

}


-(void)setupContraints{
    WeakSelf weakSelf =self;
 
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.bottom.equalTo(weakSelf.loginDisplayText.mas_top).with.offset(-30.0f);
        make.width.equalTo(@(140.0f));
        make.height.equalTo(@(160.0f));
        
    }];
    
    [self.loginDisplayText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY).with.offset(40.0f);
        make.width.equalTo(@(140.0f));
        make.height.equalTo(@(50.0f));
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.loginDisplayText.mas_bottom).with.offset(10.0f);
        make.width.equalTo(@(140.0f));
        make.height.equalTo(@(40.0f));
        
    }];


}

-(void)login{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigateToLoginPage)]) {
        [self.delegate navigateToLoginPage];
    }
}



@end
