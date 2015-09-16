//
//  LYLocationManager.h
//  LifeO2O
//
//  Created by 刘廷勇 on 15/9/4.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^LocationCallback)(BOOL success, CLLocation *currentLocation);

@interface LYLocationManager : NSObject

+ (instancetype)sharedManager;

- (void)getCurrentLocation:(LocationCallback)completion;

@end
