//
//  Activities.m
//  LifeO2O
//
//  Created by jiecongwang on 5/30/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "ShopActivities.h"
#import "ActivityCell.h"
#import "MyActivityCell.h"
#import "OtherActivityCell.h"

@interface ShopActivities()

@end

@implementation ShopActivities

@dynamic activitiesDescription;
@dynamic pics;
@dynamic shop;
@dynamic beginDate;
@dynamic endDate;
@dynamic totalNum;
@dynamic likes;
@dynamic title;
@dynamic activityType;
@dynamic participantNum;
@dynamic activityDescVoice;

- (Class)cellClass
{
    switch (self.style) {
        case OtherActivityStyleNearby:
        case OtherActivityStyleFavorite:
        case OtherActivityStyleAccepted:
            return [OtherActivityCell class];
            break;
        default:
            return [ActivityCell class];
            break;
    }
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    CGFloat height = [super heightForTableView:tableView];
    if (height == 0) {
        height = 420;
    }
    return height;
}

+ (NSString *)parseClassName
{
    return  NSStringFromClass(ShopActivities.class);
}

- (void)getActivityThumbNail:(AVImageResultBlock)block
{
    if (self.pics.count > 0) {
        NSString *objectId = self.pics[0];
       [AVFile getFileWithObjectId:objectId withBlock:^(AVFile *file, NSError *error) {
           [file getThumbnail:YES width:640.0 height:640.0 * 9.0 / 16.0 withBlock:block];
       }];
    }
}

@end
