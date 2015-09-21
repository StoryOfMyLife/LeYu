//
//  ShopFollowedCellItem.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/21.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "ShopFollowedCellItem.h"

@implementation ShopFollowedCellItem

- (Class)cellClass
{
    return [ShopFollowedCell class];
}

@end

@implementation ShopFollowedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.shopIcon = [[UIImageView alloc] init];
        self.shopIcon.image = [UIImage imageNamed:@"The news"];
        self.shopIcon.clipsToBounds = YES;
        self.shopIcon.contentMode = UIViewContentModeScaleAspectFill;
        self.shopIcon.layer.borderWidth = 2;
        self.shopIcon.layer.borderColor = RGBCOLOR(238, 238, 238).CGColor;
        self.shopIcon.layer.cornerRadius = 25;
        self.shopIcon.layer.allowsEdgeAntialiasing = YES;
        
        [self.contentView addSubview:self.shopIcon];
        
        self.shopNameLabel = [[UILabel alloc] init];
        self.shopNameLabel.font = SystemFontWithSize(15);
        self.shopNameLabel.textColor = [UIColor blackColor];
        
        [self.contentView addSubview:self.shopNameLabel];
        
        self.shopInfo = [[UILabel alloc] init];
        self.shopInfo.font = SystemFontWithSize(13);
        self.shopInfo.textColor = RGBCOLOR(168, 168, 168);
        
        [self.contentView addSubview:self.shopInfo];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    CGFloat inset = 20;
    
    [self.shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(inset);
        make.width.height.mas_equalTo(50);
        make.top.equalTo(self.contentView).offset(inset/2);
        make.bottom.equalTo(self.contentView).offset(-inset/2);
    }];
    
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopIcon.mas_right).offset(inset);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-inset/4);
        make.right.equalTo(self.contentView).offset(-inset);
    }];
    
    [self.shopInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopNameLabel);
        make.top.equalTo(self.contentView.mas_centerY).offset(inset/4);
        make.right.equalTo(self.contentView).offset(-inset);
    }];
}

- (void)setCellItem:(ShopFollowedCellItem *)cellItem
{
    [super setCellItem:cellItem];
    Shop *shop = cellItem.shop;
    
    self.shopNameLabel.text = shop.shopname;
    self.shopInfo.text = shop.shopdescription;
    
    [shop.shopIcon getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
        [UIView transitionWithView:self.shopIcon duration:.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.shopIcon.image = image;
        } completion:nil];
    }];
}

@end
