//
//  MyActivities.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/6/22.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "MyActivities.h"
#import "MyActivityCell.h"

@implementation MyActivities

@dynamic activitiesDescription;

@dynamic shopId;

@dynamic activitiesType;

@dynamic thumbnail;

@dynamic userId;

- (Class)cellClass
{
    return [MyActivityCell class];
}

+ (NSString *)parseClassName
{
    return  NSStringFromClass([MyActivities class]);
}

- (void)getActivityThumbNail:(AVDataResultBlock)block
{
    [self.thumbnail getDataInBackgroundWithBlock:block];
}

@end
