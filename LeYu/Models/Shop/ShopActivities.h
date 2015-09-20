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

@property (nonatomic, copy) NSString *activitiesDescription;

@property (nonatomic, strong) NSArray *pics;

@property (nonatomic, strong) Shop *shop;

@property (nonatomic, strong) NSDate *BeginDate;

@property (nonatomic, strong) NSDate *EndDate;

@property (nonatomic, strong) NSNumber *totalNum;

@property (nonatomic, strong) NSNumber *likes;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSNumber *activitiesType;

@property (nonatomic, strong) NSNumber *participantNum;

@property (nonatomic) BOOL accepted;

@property (nonatomic) BOOL otherActivity;

- (void)getActivityThumbNail:(AVImageResultBlock)block;

@end
