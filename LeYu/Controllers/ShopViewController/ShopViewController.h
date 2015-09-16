//
//  ShopViewController.h
//  LifeO2O
//
//  Created by 刘廷勇 on 15/9/9.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "LViewController.h"
#import "Shop.h"

@interface ShopViewController : LViewController <UIViewControllerTransitioningDelegate>

- (instancetype)initWithShop:(Shop *)shop;

@property (nonatomic, assign) CGRect presentedRect;

@end
