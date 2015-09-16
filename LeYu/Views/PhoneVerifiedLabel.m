//
//  PhoneVerifiedLabel.m
//  LifeO2O
//
//  Created by jiecongwang on 7/13/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "PhoneVerifiedLabel.h"

@interface PhoneVerifiedLabel()

@property (nonatomic,strong) UILabel *prefixEmpytLabel;

@end

@implementation PhoneVerifiedLabel

- (instancetype)init
{
    if (self = [super init]) {
        self.prefixEmpytLabel = [[UILabel alloc] init];
        [self addSubview:self.prefixEmpytLabel];
        
        self.verifiedCodeField = [[LYUITextField alloc] initWithPlaceholder:@"验证码"];
        [self addSubview:self.verifiedCodeField];
        
        self.countingLabel = [[UICountingLabel alloc] init];
        self.countingLabel.alpha = 0;
        [[self.countingLabel layer] setBorderColor:UIColorFromRGB(0xC4A24A).CGColor];
        [[self.countingLabel layer] setBorderWidth:1.0f];
        self.countingLabel.layer.cornerRadius = 20;
        self.countingLabel.textColor = DefaultYellowColor;
        self.countingLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.countingLabel];
        self.countingLabel.format = @"%d";
        self.countingLabel.method = UILabelCountingMethodLinear;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resentCode)];
        [self.countingLabel setGestureRecognizers:@[gesture]];
        
        [self setUpConstraint];

    }
    return self;
}

- (void)setUpConstraint
{
    [self.verifiedCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(50);
        make.top.bottom.equalTo(self);
    }];
    
    [self.countingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.width.equalTo(@(80.0f));
        make.height.equalTo(@(40));
    }];
}

- (void)setTimeOut
{
    [self.countingLabel countFrom:300 to:0 withDuration:300];
}

- (void)resentCode
{
   self.countingLabel.text = @"重发中...";
    if (self.delegate) {
        [self.delegate resentCode];
    }
}


@end
