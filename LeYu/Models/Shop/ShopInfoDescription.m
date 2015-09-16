//
//  ShopInfoDescription.m
//  LifeO2O
//
//  Created by jiecongwang on 6/23/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "ShopInfoDescription.h"
#import "ShopDescriptionCell.h"

@implementation ShopInfoDescription

@dynamic shopId;

@dynamic componentDescription;

@dynamic componentPicture;

- (Class)cellClass
{
    return [ShopDescriptionCell class];
}

+ (NSString *)parseClassName
{
    return  NSStringFromClass(ShopInfoDescription.class);
}

@end
