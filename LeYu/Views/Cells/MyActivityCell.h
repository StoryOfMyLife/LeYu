//
//  MyActivityCell.h
//  LifeO2O
//
//  Created by 刘廷勇 on 15/6/22.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "LTableViewCell.h"

@interface MyActivityCell : LTableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *thumbnailImage;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *dateContentLabel;
@property (nonatomic, strong) UIButton *actionButton;

@end
