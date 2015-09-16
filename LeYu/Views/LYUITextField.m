//
//  LYUITextField.m
//  LifeO2O
//
//  Created by jiecongwang on 7/9/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "LYUITextField.h"
#import <AFViewShaker.h>
#import "StringFactory.h"

@interface LYUITextField() <UITextFieldDelegate>

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) UIColor *color;

@property (nonatomic,assign) UIEdgeInsets textEdgeInsets;

@property (nonatomic,strong) AFViewShaker *viewShaker;

@property (nonatomic,assign) BOOL isEmptyError;

@property (nonatomic,assign) BOOL isPasswordType;

@end

@implementation LYUITextField


-(instancetype) initWithPlaceholder:(NSString *)placeholder {
    if (self = [super init]) {
        self.textField = [[UITextField alloc] init];
        self.textField.placeholder = placeholder;
        self.textField.delegate = self;
        self.textField.textColor = [UIColor grayColor];
        self.color = [UIColor grayColor];
        self.isPasswordType =  NO;
        self.flagError = NO;
        self.isEmptyError =  NO;
        [self addSubview:self.textField];
        self.viewShaker = [[AFViewShaker alloc] initWithView:self.textField];
        [self setUpConstraints];
        
        
    }
    return self;
}

-(instancetype) initWithPlaceholder:(NSString *)placeholder WithEdgeInsets:(UIEdgeInsets)textEdgeInsets; {
    if (self = [self initWithPlaceholder:placeholder]) {
        if (textEdgeInsets.left || textEdgeInsets.right || textEdgeInsets.top || textEdgeInsets.bottom) {
            CGFloat left =textEdgeInsets.left;
            CGFloat right = textEdgeInsets.right;
            CGFloat bottom =textEdgeInsets.bottom;
            CGFloat top = textEdgeInsets.top;
            WeakSelf weakSelf = self;
            [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.mas_top).with.offset(top);
                make.left.equalTo(weakSelf.mas_left).with.offset(left);
                make.right.equalTo(weakSelf.mas_right).with.offset(-right);
                make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-bottom);
            }];
        }
    }
    return self;
}



-(void)setUpConstraints{
    WeakSelf weakself =self;
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself);
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.isPasswordType) {
        self.textField.secureTextEntry = YES;
    }
    if (self.isEmptyError) {
        self.isEmptyError = NO;
        self.flagError =NO;
        self.textField.text = nil;
        [self backToNormal];
    }
    if (self.flagError) {
        [self backToNormal];
        self.flagError = NO;
    }
    if (self.shouldBeginTextEditingHandler) {
        return self.shouldBeginTextEditingHandler(textField);
    }
    return YES;
};

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.didBeginTextEditingHandler) {
        self.didBeginTextEditingHandler(textField);
    }
    
};

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (self.shouldEndTextEditingHandler) {
        return self.shouldEndTextEditingHandler(textField);
    }
    return YES;
};

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.didEndTextEditingHandler) {
        return self.didEndTextEditingHandler(textField);
    }
};

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.characterChangeInRangeWithReplaceStringHanlder) {
        return self.characterChangeInRangeWithReplaceStringHanlder(textField,range,string);
    }
    return YES;

};

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.textFieldShouldClearHandler) {
        return self.textFieldShouldClearHandler(textField);
    }
    if (self.flagError || self.isEmptyError) {
        return YES;
    }
    return NO;

};
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.textFieldShouldReturnHandler) {
        return self.textFieldShouldReturnHandler(textField);
    }
    return NO;
};

-(void)setError {
    [self.viewShaker shake];
    self.flagError = YES;
    self.textField.textColor = [UIColor redColor];
    [self.textField setNeedsDisplay];
}

-(void)setTextColor:(UIColor *)color {
    self.color = color;
    self.textField.textColor = color;
}

-(void)backToNormal {
    if (self.color) {
        self.textField.textColor = self.color;
    }
}

-(void)setKeyboardType:(UIKeyboardType) keyboardType {
    self.textField.keyboardType = keyboardType;
}

-(NSString *)getText{
    return self.textField.text;
}

-(void)resignResponder {
    [self.textField resignFirstResponder];
}

-(void)becomeResponder {
    [self.textField becomeFirstResponder];
}

-(void)typeAsPassword {
    self.isPasswordType = YES;
    self.textField.secureTextEntry = YES;
}

-(BOOL)isResponder {
    return [self.textField isFirstResponder];
}



-(BOOL) textContentNotEmpty {
    if ([StringFactory isEmptyString:self.textField.text]) {
        self.textField.text = @"不能为空";
        if (self.isPasswordType) {
            self.textField.secureTextEntry =  NO;
        }
        self.isEmptyError =YES;
        [self setError];
        return NO;
    }
    return YES;

}


@end
