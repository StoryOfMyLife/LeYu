//
//  LYLocationManager.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/9/4.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "LYLocationManager.h"

@interface LYLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSMutableArray *callbacks;
@property (nonatomic, assign) BOOL isMonitoring;

@end

@implementation LYLocationManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static LYLocationManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[LYLocationManager alloc] init];
        manager.isMonitoring = NO;
    });
    return manager;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // Set a movement threshold for new events
        _locationManager.distanceFilter = 10;
        [_locationManager requestAlwaysAuthorization];
    }
    return _locationManager;
}

- (NSMutableArray *)callbacks
{
    if (!_callbacks) {
        _callbacks = [NSMutableArray arrayWithCapacity:0];
    }
    return _callbacks;
}

- (void)getCurrentLocation:(LocationCallback)completion
{
    if (self.currentLocation) {
        completion(YES, self.currentLocation);
    } else {
        [self.callbacks addObject:completion];
        if (!self.isMonitoring) {
            [self startUpdates];
        }
    }
}
//- (void)getDistanceFromLocation:(CLLocation *)location completion:(DistanceCallback)completion
//{
//    if ([CLLocationManager locationServicesEnabled]) {
//        
//    }
//    
//}

- (void)startUpdates
{
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    
    self.currentLocation = locations[0];
    weakSelf();
    [self.callbacks enumerateObjectsUsingBlock:^(LocationCallback obj, NSUInteger idx, BOOL *stop) {
        obj(YES, weakSelf.currentLocation);
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    [self.callbacks enumerateObjectsUsingBlock:^(LocationCallback obj, NSUInteger idx, BOOL *stop) {
        obj(NO, nil);
    }];
}

@end
