//
//  ImageFactory.h
//  LifeO2O
//
//  Created by jiecongwang on 5/28/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageFactory : NSObject

+(UIImage *) homeTabBarIcon;

+(UIImage *) homeTabBarIconSelected;

+(UIImage* ) activityTabBarIconSelected;

+(UIImage* ) activityTabBarIcon;

+(UIImage *) userProfilesTabBarIcon;

+(UIImage *) userProfilesTabBarIconSelected;

+ (UIImage *)messageTabbarIcon;

+ (UIImage *)messageTabbarIconSelected;

+(UIImage*) getScaleImages:(NSString *)imageName;

+(UIImage *)getImages:(NSString *)imageName;

+(UIImage *)shopContactLabelBackground;

@end
