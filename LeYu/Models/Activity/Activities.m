//
//  Activities.m
//  LifeO2O
//
//  Created by jiecongwang on 5/30/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "Activities.h"
#import "ActivityCell.h"

@interface Activities()

@end

@implementation Activities

@dynamic gifts;

@dynamic likes;

@dynamic activityDate;

@dynamic activitiesDescription;

@dynamic shopId;

@dynamic activitiesType;

@dynamic thumbnail;

@dynamic otherImages;

@dynamic userId;

- (Class)cellClass
{
    return [ActivityCell class];
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
    return  NSStringFromClass(Activities.class);
}

- (void)getActivityThumbNail:(AVDataResultBlock)block
{
    [self.thumbnail getDataInBackgroundWithBlock:block];
}

@end
