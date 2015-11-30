//
//  ActivityLinks.h
//  LeYu
//
//  Created by 刘廷勇 on 15/11/30.
//  Copyright © 2015年 liuty. All rights reserved.
//

#import "LTableViewCellItem.h"
#import "ShopActivities.h"

@interface ActivityLinkTypes : LTableViewCellItem

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *pattern;

@end

@interface ActivityLinks : LTableViewCellItem

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) ActivityLinkTypes *linkType;
@property (nonatomic, strong) ShopActivities *activity;

@end


