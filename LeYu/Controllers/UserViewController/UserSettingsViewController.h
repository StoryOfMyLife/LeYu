//
//  UserSettingsViewController.h
//  LifeO2O
//
//  Created by jiecongwang on 7/24/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYUser.h"
#import "LViewController.h"

typedef NS_ENUM(NSUInteger, UserSettingSections) {
    UserGeneralSetting,
    AboutUs,
    UserSettingSectionCount
};

typedef NS_ENUM(NSUInteger,UserGeneralSettingSection){
    Notification,
    Privacy,
    General,
    UserGeneralSettingSectionCount

};

@interface UserSettingsViewController : LViewController

-(instancetype)initWithUser:(LYUser *)user;

@end
