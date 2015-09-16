//
//  NotificationMessage.h
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/27.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "AVObject.h"
#import "ShopActivities.h"

@interface NotificationMessage : AVObject<AVSubclassing>

@property (nonatomic,strong) Shop *shop;

@property (nonatomic,strong) ShopActivities *activites;

@property (nonatomic,assign) BOOL newActivites;

@end
