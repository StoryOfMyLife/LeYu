//
//  UserInfoDetailViewController.h
//  LifeO2O
//
//  Created by jiecongwang on 7/23/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

typedef NS_ENUM (NSInteger, UserInfoDetailSection) {
    UserInfoBasic,
    UserPersonalized,
    UserSignature,
    UserInfoDetailSectionCount
};

typedef NS_ENUM(NSInteger, UserInfoBasicSection)  {
   UserThumbnail,
   UserNickName,
   UserSex,
   UserInfoBasicSectionCount
};

typedef NS_ENUM(NSInteger, UserPersonalizedSeciton) {
   UserPersonalizedExplaination,
   UserPersonalizedBackground,
   UserTelephoneNumber,
   UserPersonalizedSecitonCount
};

#import <UIKit/UIKit.h>
#import "LYUser.h"
#import "LViewController.h"



@interface UserInfoDetailViewController : LViewController

-(instancetype) initWithUser:(LYUser *)user;

@end
