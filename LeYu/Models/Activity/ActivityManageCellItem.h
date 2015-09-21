//
//  ActivityManageCellItem.h
//  LeYu
//
//  Created by 刘廷勇 on 15/9/21.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "LTableViewCellItem.h"
#import "ShopActivities.h"

@interface ActivityManageCellItem : LTableViewCellItem

@property (nonatomic, strong) ShopActivities *activity;

@end

@interface ActivityManageCell : LTableViewCell

@property (nonatomic, strong) UIImageView *imageIconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *acceptedCount;

@end
