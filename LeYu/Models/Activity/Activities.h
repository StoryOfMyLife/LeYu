//
//  Activities.h
//  LifeO2O
//
//  Created by jiecongwang on 5/30/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "LTableViewCellItem.h"
#import "Shop.h"

@interface Activities : LTableViewCellItem

@property (nonatomic, strong) Shop *shop;

@property (nonatomic, strong) NSDate *activityDate;

@property (nonatomic, copy) NSString *activitiesDescription;

@property (nonatomic, strong) NSNumber *shopId;

@property (nonatomic, strong) NSNumber *activitiesType;

@property (nonatomic, strong) AVFile *thumbnail;

@property (nonatomic, strong) NSArray *otherImages;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) NSNumber *gifts;

@property (nonatomic, strong) NSNumber *likes;

@property (nonatomic, copy) void (^shopSelectedBlock)(Shop *shop);

- (void)getActivityThumbNail:(AVDataResultBlock)block;

@end
