//
//  LYUser.h
//  LifeO2O
//
//  Created by jiecongwang on 7/19/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "Shop.h"

@interface LYUser : AVUser

@property (nonatomic,assign) BOOL hasBeenUpdate ;

@property (nonatomic,strong) AVFile* thumbnail;

@property (nonatomic,strong) NSString *sex;

@property (nonatomic,strong) NSString *personalDescription;

@property (nonatomic,strong) NSString *signature;

@property (nonatomic,strong) Shop *shop;

@end
