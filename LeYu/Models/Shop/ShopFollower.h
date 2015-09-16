//
//  ShopFollower.h
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/15.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "AVObject.h"
#import "Shop.h"
#import "LYUser.h"

@interface ShopFollower : AVObject<AVSubclassing>

@property (nonatomic,strong) LYUser *user;

@property (nonatomic,strong) Shop *shop;

@end
