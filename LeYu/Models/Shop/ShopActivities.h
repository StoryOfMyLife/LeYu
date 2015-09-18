//
//  Activities.h
//  LifeO2O
//
//  Created by jiecongwang on 5/30/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "LTableViewCellItem.h"
#import "Shop.h"

@interface ShopActivities : LTableViewCellItem

@property (nonatomic, strong) Shop *shop;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSDate *activityDate;

@property (nonatomic, copy) NSString *activitiesDescription;

@property (nonatomic, strong) NSNumber *activitiesType;

@property (nonatomic, strong) NSArray *pics;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) NSNumber *gifts;

@property (nonatomic, strong) NSNumber *likes;

@property (nonatomic) BOOL accepted;

@property (nonatomic) BOOL otherActivity;

- (void)getActivityThumbNail:(AVImageResultBlock)block;

@end
