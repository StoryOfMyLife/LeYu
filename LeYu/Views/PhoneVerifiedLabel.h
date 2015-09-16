//
//  PhoneVerifiedLabel.h
//  LifeO2O
//
//  Created by jiecongwang on 7/13/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYUITextField.h"
#import <UICountingLabel.h>

@protocol PhoneVerifiedDelegate <NSObject>

- (void)resentCode;

@end

@interface PhoneVerifiedLabel : UIView

@property (nonatomic,weak) id<PhoneVerifiedDelegate> delegate;

@property (nonatomic,strong) LYUITextField *verifiedCodeField;

@property (nonatomic,strong) UICountingLabel *countingLabel;

- (void)setTimeOut;

@end
