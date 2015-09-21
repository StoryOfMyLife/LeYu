//
//  Shop.m
//  LifeO2O
//
//  Created by jiecongwang on 6/3/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "Shop.h"

@interface Shop()

@end

@implementation Shop

@dynamic shopId;

@dynamic shopIcon;

@dynamic geolocation;

@dynamic shopname;

@dynamic address;

@dynamic shopbackground;

@dynamic shopdescription;

@dynamic likes;

@dynamic followers;

-(void)loadShopIcon:(AVImageResultBlock)block
{
    [self.shopIcon getThumbnail:YES width:100 height:100 withBlock:block];
}

@end
