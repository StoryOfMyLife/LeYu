//
//  LoginViewController.h
//  LifeO2O
//
//  Created by jiecongwang on 6/30/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LViewController.h"

@protocol UserLoginControllerDelegate <NSObject>

- (void)exitLoginProcess;

@optional

- (void)loginCallback;

@end

@interface LoginAndSignUpViewController : LViewController

@property (nonatomic, weak) id<UserLoginControllerDelegate> delegate;

@end
