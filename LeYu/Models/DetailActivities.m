//
//  DetailActivities.m
//  LifeO2O
//
//  Created by jiecongwang on 6/3/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "DetailActivities.h"


@interface DetailActivities();



@end

@implementation DetailActivities



-(NSNumber *)getShopIdFromCurrentActivities {
    if (self.shop) {
        return self.shop.shopId;
    }
    if (self.activities) {
        return self.activities.shop.shopId;
    }
    return [NSNumber numberWithInt:-1];
}


@end
