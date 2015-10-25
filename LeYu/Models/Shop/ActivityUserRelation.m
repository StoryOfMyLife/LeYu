//
//  ShopFollower.m
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/15.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ActivityUserRelation.h"


@implementation ActivityUserRelation

+ (NSString *)parseClassName {
    return NSStringFromClass(ActivityUserRelation.class);
}

@dynamic user;
@dynamic activity;
@dynamic userArriveDate;
@dynamic isArrived;

@end
