//
//  LYUser.m
//  LifeO2O
//
//  Created by jiecongwang on 7/19/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "LYUser.h"

@interface LYUser() <AVSubclassing>

@end

@implementation LYUser

@dynamic personalDescription;

@dynamic hasBeenUpdate;

@dynamic sex;

@dynamic signature;

@dynamic thumbnail;

@dynamic shop;

@dynamic level;


+ (NSString *)parseClassName {
     return @"_User";
}



@end
