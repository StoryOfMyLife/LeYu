//
//  SignUpViewController.h
//  LifeO2O
//
//  Created by jiecongwang on 7/4/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController_old : UIViewController

@property (nonatomic,weak) id delegate;

-(instancetype) initWithUser : (LYUser *)user;

@end
