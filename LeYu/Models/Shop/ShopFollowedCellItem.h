//
//  ShopFollowedCellItem.h
//  LeYu
//
//  Created by 刘廷勇 on 15/9/21.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "LTableViewCellItem.h"

@interface ShopFollowedCellItem : LTableViewCellItem

@property (nonatomic, strong) Shop *shop;

@end

@interface ShopFollowedCell : LTableViewCell

@property (nonatomic, strong) UIImageView *shopIcon;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *shopInfo;

@end
