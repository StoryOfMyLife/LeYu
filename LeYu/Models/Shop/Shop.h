//
//  Shop.h
//  LifeO2O
//
//  Created by jiecongwang on 6/3/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

typedef void(^ImageLoadHandler)(UIImage *image, NSError *error);

@interface Shop : AVObject<AVSubclassing>

@property NSNumber * shopId;

@property NSNumber * likes;

@property (nonatomic,copy) NSString *telephone;

@property (nonatomic,copy) NSString *shopname;

@property (nonatomic,copy) AVFile * shopIcon;

@property (nonatomic,copy) AVGeoPoint * geolocation;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) AVFile * shopbackground;

@property (nonatomic,copy) NSString* shopdescription;


- (void)loadShopIcon:(ImageLoadHandler)block;

@end
