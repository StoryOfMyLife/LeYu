//
//  MyActivities.h
//  LifeO2O
//
//  Created by 刘廷勇 on 15/6/22.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "LTableViewCellItem.h"
#import "Shop.h"

@interface MyActivities : LTableViewCellItem

@property (nonatomic, strong) Shop *shop;

@property (nonatomic,copy) NSString *activitiesDescription;

@property (nonatomic,copy) NSNumber *shopId;

@property (nonatomic, strong) NSNumber *activitiesType;

@property (nonatomic,copy) AVFile *thumbnail;

@property (nonatomic,copy) NSString *userId;

- (void)getActivityThumbNail:(AVDataResultBlock)block;

@end
