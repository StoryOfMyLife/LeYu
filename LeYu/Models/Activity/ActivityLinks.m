//
//  ActivityLinks.m
//  LeYu
//
//  Created by 刘廷勇 on 15/11/30.
//  Copyright © 2015年 liuty. All rights reserved.
//

#import "ActivityLinks.h"
#import "ActivityLinkCell.h"

@implementation ActivityLinks

@dynamic url;
@dynamic title;
@dynamic image_url;
@dynamic linkType;
@dynamic activity;

+ (NSString *)parseClassName
{
    return  NSStringFromClass([ActivityLinks class]);
}

- (Class)cellClass
{
    return [ActivityLinkCell class];
}

@end


@implementation ActivityLinkTypes

@dynamic name;
@dynamic desc;
@dynamic pattern;

+ (NSString *)parseClassName
{
    return  NSStringFromClass([ActivityLinkTypes class]);
}

@end


@implementation ActivityLinksHeaderItem

- (Class)cellClass
{
    return [ActivityLinksHeader class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 50;
}

@end
