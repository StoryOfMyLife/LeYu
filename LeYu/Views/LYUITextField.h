//
//  LYUITextField.h
//  LifeO2O
//
//  Created by jiecongwang on 7/9/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYUITextField : UIView

-(void)typeAsPassword;

-(instancetype) initWithPlaceholder:(NSString *)placeholder;

-(instancetype) initWithPlaceholder:(NSString *)placeholder WithEdgeInsets:(UIEdgeInsets)textEdgeInsets;

-(void) setError;

-(void)setTextColor:(UIColor *)color;

-(void)setKeyboardType:(UIKeyboardType) keyboardType;

-(NSString *)getText;

-(void)becomeResponder;

-(void)resignResponder;

-(BOOL)isResponder;

-(BOOL) textContentNotEmpty;



@property (nonatomic,assign) BOOL flagError;


@property (nonatomic,strong) void(^didBeginTextEditingHandler)(UITextField *textField);

@property (nonatomic,strong) BOOL(^shouldBeginTextEditingHandler)(UITextField *textField);

@property (nonatomic,strong) BOOL(^shouldEndTextEditingHandler)(UITextField *textField);

@property (nonatomic,strong) void(^didEndTextEditingHandler)(UITextField *textField);

@property (nonatomic,strong) BOOL(^characterChangeInRangeWithReplaceStringHanlder)(UITextField *textField,NSRange range,NSString *string);

@property (nonatomic,strong) BOOL(^textFieldShouldClearHandler)(UITextField *textField);

@property (nonatomic,strong) BOOL(^textFieldShouldReturnHandler)(UITextField *textFiled);



@end
