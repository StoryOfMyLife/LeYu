//
//  ActivityDetailCellItem.h
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/29.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "LTableViewCellItem.h"
#import <TTTAttributedLabel.h>
#import "ShopActivities.h"

@interface ActivityDetailCellItem : LTableViewCellItem

@property (nonatomic, strong) ShopActivities *activity;

@end

@interface ActivityDetailCell : LTableViewCell

@property (nonatomic, strong) TTTAttributedLabel *activityDescLabel;
@property (nonatomic, strong) UILabel *activityDateLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UILabel *giftLabel;

@end
