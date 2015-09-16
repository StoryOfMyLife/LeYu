//
//  NotificationMessageCell.h
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/27.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationMessageCell : UITableViewCell

-(void)configureNotificationMessage:(BOOL)newActivities withShopName:(NSString *)shopName;

@end
