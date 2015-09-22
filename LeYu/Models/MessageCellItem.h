//
//  MessageCellItem.h
//  LeYu
//
//  Created by 刘廷勇 on 15/9/23.
//  Copyright © 2015年 liuty. All rights reserved.
//

#import "LTableViewCellItem.h"
#import "ShopActivities.h"

@interface MessageCellItem : LTableViewCellItem

@property (nonatomic, strong) ShopActivities *activity;
@property (nonatomic, strong) NSDate *arrivedDate;

@end

@interface MessageCell : LTableViewCell

@property (nonatomic, strong) UIImageView *shopIcon;
@property (nonatomic, strong) UILabel *message;

@end