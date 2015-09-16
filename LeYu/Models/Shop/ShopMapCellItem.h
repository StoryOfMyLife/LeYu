//
//  ShopMapCellItem.h
//  LeYu
//
//  Created by 刘廷勇 on 15/9/16.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "LTableViewCellItem.h"
#import "Shop.h"

@interface ShopMapCellItem : LTableViewCellItem

@property (nonatomic, strong) Shop *shop;

@end

@interface ShopMapCell : LTableViewCell

@end
