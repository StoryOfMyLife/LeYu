//
//  ShopFollower.h
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/15.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "AVObject.h"
#import "ShopActivities.h"
#import "LYUser.h"

@interface ActivityUserRelation : AVObject <AVSubclassing>

@property (nonatomic, strong) LYUser *user;

@property (nonatomic, strong) ShopActivities *activity;

@property (nonatomic, strong) NSDate *userArriveDate;

@property (nonatomic, assign) BOOL isArrived;

@end
