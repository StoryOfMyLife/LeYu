//
//  ActivityWebviewController.h
//  LeYu
//
//  Created by 刘廷勇 on 15/10/27.
//  Copyright © 2015年 liuty. All rights reserved.
//

#import "LViewController.h"
#import "ShopActivities.h"

@interface ActivityWebviewController : LViewController

@property (nonatomic, strong) NSString *urlID;
@property (nonatomic, strong) NSString *urlString;

@property (nonatomic, strong) ShopActivities *activity;


@end
