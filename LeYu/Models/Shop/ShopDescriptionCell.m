//
//  ShopDescriptionCell.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/9/14.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ShopDescriptionCell.h"

const CGFloat kComponentPicture =  240;

@interface ShopDescriptionCell ()

@property (nonatomic,strong) UILabel *descriptions;

@property (nonatomic,strong) UIImageView *componentPicture;

@end

@implementation ShopDescriptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.descriptions = [[UILabel alloc] init];
        self.descriptions.numberOfLines = 0;
        self.descriptions.lineBreakMode = NSLineBreakByWordWrapping;
        self.descriptions.textColor = UIColorFromRGB(0x969696);
        [self.descriptions setPreferredMaxLayoutWidth:self.contentView.width - 30.0f];
        [self.contentView addSubview:self.descriptions];
        
        self.componentPicture = [[UIImageView alloc] init];
        self.componentPicture.contentMode = UIViewContentModeScaleAspectFill;
        self.componentPicture.clipsToBounds = YES;
        [self.contentView addSubview:self.componentPicture];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    WeakSelf weakSelf =self;
    [self.componentPicture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.contentView);
        make.height.equalTo(@(kComponentPicture));
    }];
    
    [self.descriptions mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.componentPicture.mas_bottom).with.offset(15.0f);
        make.left.equalTo(weakSelf.contentView).with.offset(15.0f);
        make.right.equalTo(weakSelf.contentView).with.offset(-15);
        make.bottom.equalTo(weakSelf.contentView).with.offset(-15);
    }];
}

- (void)setCellItem:(ShopInfoDescription *)cellItem
{
    [super setCellItem:cellItem];
    self.descriptions.text = [cellItem.componentDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];;

    [cellItem.componentPicture getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            [UIView transitionWithView:self.componentPicture duration:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.componentPicture.image = image;
            } completion:nil];
        }
    }];
}

@end
