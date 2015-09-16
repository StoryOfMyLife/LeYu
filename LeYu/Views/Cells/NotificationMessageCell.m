//
//  NotificationMessageCell.m
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/27.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "NotificationMessageCell.h"


@implementation NotificationMessageCell


-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageView.image = [UIImage imageNamed:@"thenews"];
        self.textLabel.text = @"系统通知";
        
    }
    return self;
}

-(void)configureNotificationMessage:(BOOL)newActivities withShopName:(NSString *)shopName{
    if (newActivities) {
        self.detailTextLabel.text =  [[@"尊敬的用户，您刚刚参加" stringByAppendingString:shopName] stringByAppendingString:@"活动"];
    }else {
        self.detailTextLabel.text = [[@"您参与" stringByAppendingString:shopName] stringByAppendingString:@"的活动快结束了，赶快去参加吧"];
    }
}



@end
