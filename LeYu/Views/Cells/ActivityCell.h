//
//  ActivityCell.h
//  LifeO2O
//
//  Created by 刘廷勇 on 15/6/20.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "LTableViewCell.h"

@interface ActivityCell : LTableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *thumbnailImage;
@property (nonatomic, strong) UIImageView *shopIcon;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *giftNumberLabel;
@property (nonatomic, strong) UILabel *distanceLabel;

@end
