//
//  MacroHelper.h
//  LBase
//
//  Created by 刘廷勇 on 15/4/7.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#ifndef LBase_MacroHelper_h
#define LBase_MacroHelper_h

#pragma mark
#pragma mark - Log

    #ifdef DEBUG
        #define Log(fmt, ...) do {                                            \
            NSString* file = [NSString stringWithFormat:@"%s", __FILE__]; \
            NSLog((@"%@(%d) " fmt), [file lastPathComponent], __LINE__, ##__VA_ARGS__); \
        } while(0)

        #define LogMethod() do {                                            \
            NSString* file = [NSString stringWithFormat:@"%s", __FILE__]; \
            NSLog((@"%@(%d) method:%s"), [file lastPathComponent], __LINE__, __PRETTY_FUNCTION__); \
        } while(0)
    #else
        #define Log(...)
        #define LogMethod()
    #endif

#pragma mark
#pragma mark - Block

    #define weakSelf() __weak __typeof(self) weakSelf = self
    #define strongSelf() __strong __typeof(weakSelf) strongSelf = weakSelf
    #define blockSelf() __block __typeof(self) blockSelf = self

#pragma mark
#pragma mark - Version

    #define OSVersion [[[UIDevice currentDevice] systemVersion] floatValue]
    #define YDAvalibleOS(os_version) OSVersion >= os_version

    #define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <  568.0)
    #define IS_IPHONE_5         (IS_IPHONE && fabs((double)SCREEN_MAX_LENGTH - (double)568) < DBL_EPSILON)
    #define IS_IPHONE_6         (IS_IPHONE && fabs((double)SCREEN_MAX_LENGTH - (double)667) < DBL_EPSILON)
    #define IS_IPHONE_6P        (IS_IPHONE && fabs((double)SCREEN_MAX_LENGTH - (double)736) < DBL_EPSILON)

#pragma mark
#pragma mark - Singleton

    #define DECLARE_SHARED_INSTANCE  \
    + (instancetype)sharedInstance;


    #define IMPLEMENT_SHARED_INSTANCE \
    + (instancetype)sharedInstance \
    { \
        static dispatch_once_t onceToken; \
        static id sharedInstance = nil; \
        dispatch_once(&onceToken, ^{ \
            sharedInstance = [[[self class] alloc] init]; \
        }); \
        return sharedInstance; \
    }

#pragma mark
#pragma mark - UI

    #define px (1.0 / [UIScreen mainScreen].scale)

    #define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
    #define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
    alpha:(a)]

    #define RGBCOLOR_HEX(h) RGBCOLOR((((h)>>16)&0xFF), (((h)>>8)&0xFF), ((h)&0xFF))
    #define RGBACOLOR_HEX(h,a) RGBACOLOR((((h)>>16)&0xFF), (((h)>>8)&0xFF), ((h)&0xFF), (a))
    #define RGBPureColor(h) RGBCOLOR(h, h, h)

    #define HSVCOLOR(h,s,v) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:1]
    #define HSVACOLOR(h,s,v,a) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]

    #define RGBA(r,g,b,a) (r)/255.0f, (g)/255.0f, (b)/255.0f, (a)

    #define SystemFontWithSize(size) [UIFont systemFontOfSize:size]
    #define SystemBoldFontWithSize(size) [UIFont boldSystemFontOfSize:size]

#pragma mark
#pragma mark - Image

    #define LAUNCH_IMAGE_IPHONE4  @"LaunchImage-700"
    #define LAUNCH_IMAGE_IPHONE5  @"LaunchImage-700-568h"
    #define LAUNCH_IMAGE_IPHONE6  @"LaunchImage-800-667h"
    #define LAUNCH_IMAGE_IPHONE6P @"LaunchImage-800-Portrait-736h"

#pragma mark
#pragma mark - Frame

    #define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
    #define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

#pragma mark
#pragma mark - Time

    #define aDay 60.0 * 60.0 * 24.0
    #define aWeek aDay * 7.0

#endif
