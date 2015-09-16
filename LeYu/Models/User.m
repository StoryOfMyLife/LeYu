//
//  User.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/6/28.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "User.h"
#import "ActivityUserInfoCell.h"

@implementation User

//+ (NSString *)parseClassName
//{
//    return  NSStringFromClass([User class]);
//}

- (Class)cellClass
{
    return [ActivityUserInfoCell class];
}

@end
