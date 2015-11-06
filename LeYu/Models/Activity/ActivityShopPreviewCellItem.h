//
//  ActivityShopPreviewCellItem.h
//  LeYu
//
//  Created by 刘廷勇 on 15/11/7.
//  Copyright © 2015年 liuty. All rights reserved.
//

#import "LTableViewCellItem.h"

@interface ActivityShopPreviewCellItem : LTableViewCellItem

@property (nonatomic, strong) Shop *shop;

@end


@interface ActivityShopPreviewCell : LTableViewCell

@property (nonatomic, strong) UILabel *shopName;
@property (nonatomic, strong) UILabel *shopAddress;

@end
