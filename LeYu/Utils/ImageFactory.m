//
//  ImageFactory.m
//  LifeO2O
//
//  Created by jiecongwang on 5/28/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "ImageFactory.h"
#import "ColorFactory.h"

static UIImage*  _homeTabBarIcon = nil;
static UIImage*  _homeTabBarIconSelected = nil;
static UIImage*  _activityTabBarIconSelected = nil;
static UIImage*  _activityTabBarIcon = nil;
static UIImage*  _userProfilesTabBarIcon = nil;
static UIImage*  _userProfilesTabBarIconSelected =nil;
static UIImage*  _messageTabbarIcon = nil;
static UIImage*  _messageTabbarIconSelected = nil;
static UIImage*  _shopContactLabelBackground = nil;
static UIImage*  _newNotificationBackground = nil;
static UIImage*  _newNotificationBackgroundSelected = nil;


@implementation ImageFactory

+(UIImage *) homeTabBarIcon {
    if (!_homeTabBarIcon) {
        _homeTabBarIcon = [ImageFactory getScaleImages:@"home"];
        
    }
    return _homeTabBarIcon;
};

+(UIImage *) homeTabBarIconSelected{
    if (!_homeTabBarIconSelected) {
        _homeTabBarIconSelected = [ImageFactory getScaleImages:@"home_selected"];
    }
    return _homeTabBarIconSelected;
}

+(UIImage* ) activityTabBarIconSelected{
    if (!_activityTabBarIconSelected) {
        _activityTabBarIconSelected = [ImageFactory getScaleImages:@"activity_selected"];
    }
    return _activityTabBarIconSelected;
}


+ (UIImage* )activityTabBarIcon{
    if (!_activityTabBarIcon) {
        _activityTabBarIcon = [ImageFactory getScaleImages:@"activity"];
    }
    return _activityTabBarIcon;
}

+ (UIImage *)userProfilesTabBarIcon{
    if (!_userProfilesTabBarIcon) {
        _userProfilesTabBarIcon = [ImageFactory getScaleImages:@"user"];
    }
    return _userProfilesTabBarIcon;
}

+ (UIImage *)userProfilesTabBarIconSelected {
    if (!_userProfilesTabBarIconSelected) {
        _userProfilesTabBarIconSelected = [ImageFactory getScaleImages:@"user_selected"];
    }
    return _userProfilesTabBarIconSelected;
}

+ (UIImage *)messageTabbarIcon {
    if (!_messageTabbarIcon) {
        _messageTabbarIcon = [ImageFactory getScaleImages:@"news"];
    }
    return _messageTabbarIcon;
}

+ (UIImage *)messageTabbarIconSelected {
    if (!_messageTabbarIconSelected) {
        _messageTabbarIconSelected = [ImageFactory getScaleImages:@"news_selected"];
    }
    return _messageTabbarIconSelected;
}

+(UIImage*) getScaleImages:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
   return [[UIImage imageWithCGImage:image.CGImage scale:2.0f orientation:image.imageOrientation] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+(UIImage *)getImages:(NSString *)imageName{
     UIImage *image = [UIImage imageNamed:imageName];
    return image;

}

+ (UIImage *)shopContactLabelBackground
{
    //TODO:
    return nil;
}




@end
