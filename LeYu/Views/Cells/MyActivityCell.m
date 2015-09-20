//
//  MyActivityCell.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/6/22.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "MyActivityCell.h"
#import "MyActivities.h"
#import "LineDashView.h"

static const CGFloat kContentInset = 10;

@interface MyActivityCell ()

@property (nonatomic, strong) LineDashView *seperator;

@property (nonatomic, strong) UIView *bottomView;

@end

@implementation MyActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = SystemFontWithSize(16);
    self.titleLabel.textColor = [UIColor blackColor];
    
    self.thumbnailImage = [[UIImageView alloc] init];
    self.thumbnailImage.contentMode = UIViewContentModeScaleAspectFill;
    
    self.shopNameLabel = [[UILabel alloc] init];
    self.shopNameLabel.font = SystemFontWithSize(15);
    self.shopNameLabel.textColor = RGBCOLOR_HEX(0xc4a24a);
    
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.textAlignment = NSTextAlignmentRight;
    self.distanceLabel.font = SystemFontWithSize(10);
    self.distanceLabel.textColor = RGBCOLOR_HEX(0x1f1f1f);
    
    self.seperator = [[LineDashView alloc] initWithFrame:CGRectZero lineDashPattern:@[@2, @2] endOffset:0.495];
    self.seperator.backgroundColor = RGBCOLOR_HEX(0xe0e0e0);
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.text = @"活动时间";
    self.dateLabel.font = SystemFontWithSize(14);
    self.dateLabel.textColor = RGBCOLOR_HEX(0xc4a24a);
    
    self.dateContentLabel = [[UILabel alloc] init];
    self.dateContentLabel.textColor = RGBCOLOR_HEX(0x646464);
    self.dateContentLabel.font = SystemFontWithSize(12);
    
//    self.actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    self.actionButton.backgroundColor = RGBCOLOR_HEX(0xc4a24a);
//    [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.actionButton.titleLabel.font = SystemFontWithSize(14);
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = DefaultBackgroundColor;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.thumbnailImage];
    [self.contentView addSubview:self.shopNameLabel];
    [self.contentView addSubview:self.distanceLabel];
    [self.contentView addSubview:self.seperator];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.dateContentLabel];
//    [self.contentView addSubview:self.actionButton];
    [self.contentView addSubview:self.bottomView];
}

- (void)updateConstraints
{
    CGFloat titleVerticalGap = 15;
    
    weakSelf();
    UIView *superview = weakSelf.contentView;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview).with.offset(titleVerticalGap);
        make.left.equalTo(superview).with.offset(kContentInset);
        make.right.equalTo(superview).with.offset(-kContentInset);
    }];
    
    [self.thumbnailImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(superview);
        make.trailing.equalTo(superview);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).with.offset(titleVerticalGap);
        make.height.equalTo(@(SCREEN_WIDTH * 0.9));
    }];
    
    [self.shopNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.thumbnailImage.mas_bottom).with.offset(titleVerticalGap);
    }];
    
    [self.distanceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superview).with.offset(-kContentInset);
        make.centerY.equalTo(weakSelf.shopNameLabel);
    }];
    
    [self.seperator mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.shopNameLabel);
        make.right.equalTo(weakSelf.distanceLabel);
        make.top.equalTo(weakSelf.shopNameLabel.mas_bottom).with.offset(titleVerticalGap);
        make.height.equalTo(@0.5);
    }];
    
    [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.shopNameLabel);
        make.top.equalTo(weakSelf.seperator.mas_bottom).with.offset(titleVerticalGap);
    }];
    
    [self.dateContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.dateLabel);
        make.left.equalTo(weakSelf.dateLabel.mas_trailing).with.offset(kContentInset);
        make.trailing.lessThanOrEqualTo(weakSelf.distanceLabel);
    }];
    
//    [self.actionButton mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf.dateLabel);
//        make.right.equalTo(weakSelf.distanceLabel);
//        make.width.equalTo(@80);
//        make.height.equalTo(@30);
//    }];
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superview);
        make.right.equalTo(superview);
        make.bottom.equalTo(superview);
        make.top.equalTo(weakSelf.dateLabel.mas_bottom).with.offset(titleVerticalGap);
        make.height.equalTo(@15);
    }];
    
    [super updateConstraints];
}

- (void)configureCellWithActivity:(MyActivities *)activity
{
    self.titleLabel.text = activity.activitiesDescription;
    [activity getActivityThumbNail:^(NSData *data, NSError *error) {
        self.thumbnailImage.image = [UIImage imageWithData:data];
    }];
    self.shopNameLabel.text = [NSString stringWithFormat:@"@%@", activity.shop.shopname];
    self.distanceLabel.text = @"7.4km";
    self.dateContentLabel.text = @"2015.10.1 ~ 2015.11.10";
//    [self.actionButton setTitle:@"支付/积分" forState:UIControlStateNormal];
}

- (void)setCellItem:(MyActivities *)cellItem
{
    [super setCellItem:cellItem];
    [self configureCellWithActivity:cellItem];
    [self setNeedsUpdateConstraints];
}

@end
