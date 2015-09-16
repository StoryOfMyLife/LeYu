//
//  DetailActivities.h
//  LifeO2O
//
//  Created by jiecongwang on 6/3/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopActivities.h"
#import "Shop.h"

@interface DetailActivities : NSObject

@property (nonatomic,strong) ShopActivities *activities;

@property (nonatomic,strong) Shop* shop;

-(NSNumber *)getShopIdFromCurrentActivities;

@end
