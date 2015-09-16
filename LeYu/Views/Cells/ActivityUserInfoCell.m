//
//  ActivityUserInfoCell.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/6/28.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ActivityUserInfoCell.h"
#import "User.h"

static const CGFloat kContentInset = 10;

@interface ActivityUserInfoCell ()

@property (nonatomic, strong) UIView *containerView;

@end


@implementation ActivityUserInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        self.contentView.backgroundColor = UIColorFromRGB(0xF0F0F0);
    }
    return self;
}

- (void)initSubviews
{
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    
    self.name = [[UILabel alloc] init];
    self.name.font = SystemFontWithSize(15);
    self.name.textColor = RGBCOLOR_HEX(0x323232);
    
    self.signature = [[UILabel alloc] init];
    self.signature.font = SystemFontWithSize(13);
    self.signature.textColor = RGBCOLOR_HEX(0x969696);
    
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.name];
    [self.containerView addSubview:self.signature];
}

- (void)updateConstraints
{
    weakSelf();
    UIView *superview = weakSelf.contentView;
    
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview);
        make.right.equalTo(superview);
        make.top.equalTo(superview).with.offset(kContentInset * 2);
        make.bottom.equalTo(superview).with.offset(-kContentInset * 2);
        make.height.equalTo(@65);
    }];
    
    [self.name mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.containerView).with.offset(kContentInset);
        make.right.equalTo(weakSelf.containerView).with.offset(-kContentInset);
        make.top.equalTo(weakSelf.containerView).with.offset(10);
    }];
    
    [self.signature mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.name);
        make.right.equalTo(weakSelf.name);
        make.bottom.equalTo(weakSelf.containerView).with.offset(-10);
    }];
    [super updateConstraints];
}

- (void)setCellItem:(User *)cellItem
{
    [super setCellItem:cellItem];
    self.name.text = cellItem.name;
    self.signature.text = cellItem.signature;
    [self setNeedsUpdateConstraints];
}

@end
