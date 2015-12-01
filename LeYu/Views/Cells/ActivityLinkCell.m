//
//  ActivityLinkCell.m
//  LeYu
//
//  Created by 刘廷勇 on 15/11/30.
//  Copyright © 2015年 liuty. All rights reserved.
//

#import "ActivityLinkCell.h"
#import "ActivityLinks.h"
#import <UIImageView+WebCache.h>

@implementation ActivityLinkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageIconView = [[UIImageView alloc] init];
        self.imageIconView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageIconView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageIconView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.textColor = DefaultTitleColor;
        self.titleLabel.font = SystemFontWithSize(14);
        [self.contentView addSubview:self.titleLabel];
        
        UILabel *from = [[UILabel alloc] init];
        from.textColor = RGBCOLOR_HEX(0xbbbbbb);
        from.text = @"来自";
        from.font = SystemFontWithSize(12);
        [self.contentView addSubview:from];
        
        self.fromLabel = [[UILabel alloc] init];
        self.fromLabel.textColor = DefaultYellowColor;
        self.fromLabel.font = from.font;
        [self.contentView addSubview:self.fromLabel];
        
        UIView *seperator = [[UIView alloc] init];
        seperator.backgroundColor = RGBCOLOR(205, 205, 205);
        [self.contentView addSubview:seperator];
        
        CGFloat inset = 15;
        
        [self.imageIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(inset);
            make.top.equalTo(self.contentView).offset(inset);
            make.bottom.equalTo(self.contentView).offset(-inset);
            make.height.equalTo(@75);
            make.width.equalTo(@(100));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageIconView.mas_right).offset(inset);
            make.right.equalTo(self.contentView).offset(- inset);
            make.top.equalTo(self.imageIconView);
        }];
        
        [from mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.bottom.equalTo(self.imageIconView);
        }];
        
        [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(from);
            make.left.equalTo(from.mas_right).offset(5);
        }];
        
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageIconView);
            make.height.mas_equalTo(0.5);
            make.right.equalTo(self.contentView).offset(-inset);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setCellItem:(ActivityLinks *)cellItem
{
    [super setCellItem:cellItem];
    self.titleLabel.text = cellItem.title;
    self.fromLabel.text = cellItem.linkType.desc;
    [self.imageIconView sd_setImageWithURL:[NSURL URLWithString:cellItem.image_url]];
}

@end

@implementation ActivityLinksHeader

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *leftLine = [[UIView alloc] init];
        leftLine.backgroundColor = RGBCOLOR_HEX(0xd7d7d7);
        [self.contentView addSubview:leftLine];
        
        UIView *rightLine = [[UIView alloc] init];
        rightLine.backgroundColor = leftLine.backgroundColor;
        [self.contentView addSubview:rightLine];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"乐鱼优选";
        self.titleLabel.font = SystemFontWithSize(16);
        self.titleLabel.textColor = DefaultYellowColor;
        [self.contentView addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.width.mas_equalTo(55);
            make.height.mas_equalTo(0.5);
            make.right.mas_equalTo(self.titleLabel.mas_left).offset(-20);
        }];
        
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftLine);
            make.width.height.equalTo(leftLine);
            make.left.equalTo(self.titleLabel.mas_right).offset(20);
        }];
    }
    return self;
}

- (void)setCellItem:(ActivityLinksHeaderItem *)cellItem
{
    [super setCellItem:cellItem];
    if (cellItem.title.length > 0) {
        self.titleLabel.text = cellItem.title;
    }
}

@end
