//
//  PhoneVerifiedLabel.m
//  LifeO2O
//
//  Created by jiecongwang on 7/13/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "PhoneVerifiedLabel.h"

#import  <UICountingLabel.h>

@interface PhoneVerifiedLabel()

@property (nonatomic,strong) UILabel *prefixEmpytLabel;


@property (nonatomic,strong) UICountingLabel *countingLabel;

@end

@implementation PhoneVerifiedLabel


-(instancetype) init {
    if (self = [super init]) {
        self.prefixEmpytLabel = [[UILabel alloc] init];
        [self addSubview:self.prefixEmpytLabel];
        
        self.verifiedCodeField = [[LYUITextField alloc] initWithPlaceholder:@"验证码"];
        [self addSubview:self.verifiedCodeField];
        
        self.countingLabel = [[UICountingLabel alloc] init];
        [[self.countingLabel layer] setBorderColor:UIColorFromRGB(0xC4A24A).CGColor];
        [[self.countingLabel layer] setBorderWidth:1.0f];
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


-(void)setUpConstraint{
    WeakSelf weakSelf =self;
    [self.prefixEmpytLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(10.0f);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.top.equalTo(weakSelf.mas_top);
        make.width.equalTo(weakSelf.mas_width).dividedBy(3);
    }];
    
    [self.verifiedCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.prefixEmpytLabel.mas_right);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.top.equalTo(weakSelf.mas_top);
        make.width.equalTo(weakSelf.mas_width).dividedBy(3);
    }];
    
    [self.countingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.verifiedCodeField.mas_right);
        make.top.equalTo(weakSelf.mas_top).with.offset(5.0f);
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-5.0f);
        make.width.equalTo(@(80.0f));
    }];

}


-(void)setTimeOut {
    [self.countingLabel countFrom:300 to:0 withDuration:300];

}

-(void)resentCode {
   self.countingLabel.text = @"重发中...";
    if (self.delegate) {
        [self.delegate resentCode];
    }
}


@end
