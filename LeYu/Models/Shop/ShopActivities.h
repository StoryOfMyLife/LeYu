//
//  Activities.h
//  LifeO2O
//
//  Created by jiecongwang on 5/30/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "LTableViewCellItem.h"
#import "Shop.h"

typedef NS_ENUM(NSUInteger, ActivityType) {
    ActivityTypeNormal = 1,
    ActivityTypeArticle = 2
};

typedef NS_ENUM(NSUInteger, OtherActivityStyle) {
    OtherActivityStyleOther,
    OtherActivityStyleAccepted,
    OtherActivityStyleNearby,
    OtherActivityStyleFavorite
};

@interface ShopActivities : LTableViewCellItem

@property (nonatomic, assign) BOOL isApproved;

@property (nonatomic, assign) CGFloat rank;

@property (nonatomic, copy) NSString *activitiesDescription;

@property (nonatomic, strong) NSArray *pics;

@property (nonatomic, strong) Shop *shop;

@property (nonatomic, strong) NSDate *beginDate;

@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, strong) NSNumber *totalNum;

@property (nonatomic, strong) NSNumber *likes;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSNumber *activityType;

@property (nonatomic, strong) NSNumber *participantNum;

@property (nonatomic, strong) AVFile *activityDescVoice;

@property (nonatomic, assign) OtherActivityStyle style;

@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, assign) BOOL cached;

- (void)getActivityThumbNail:(AVImageResultBlock)block;

@end
