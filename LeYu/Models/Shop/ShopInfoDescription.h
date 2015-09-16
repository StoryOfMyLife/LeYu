//
//  ShopInfoDescription.h
//  LifeO2O
//
//  Created by jiecongwang on 6/23/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "LTableViewCellItem.h"

@interface ShopInfoDescription : LTableViewCellItem

@property (nonatomic,strong) NSNumber *shopId;

@property (nonatomic,strong) AVFile *componentPicture;

@property (nonatomic,strong) NSString *componentDescription;

@end
