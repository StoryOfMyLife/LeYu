//
//  ActivityShopPreviewCellItem.m
//  LeYu
//
//  Created by 刘廷勇 on 15/11/7.
//  Copyright © 2015年 liuty. All rights reserved.
//

#import "ActivityShopPreviewCellItem.h"

@implementation ActivityShopPreviewCellItem

- (Class)cellClass
{
    return [ActivityShopPreviewCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 80;
}

@end


@implementation ActivityShopPreviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.shopName = [[UILabel alloc] init];
        self.shopName.font = SystemBoldFontWithSize(24);
        self.shopName.textColor = DefaultYellowColor;
        [self.contentView addSubview:self.shopName];
        
        [self.shopName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
//            make.bottom.equalTo(self.contentView.mas_centerY).offset(-10);
        }];
        
//        self.shopAddress = [[UILabel alloc] init];
//        self.shopAddress.font = SystemFontWithSize(13);
//        self.shopAddress.textColor = DefaultTitleColor;
//        [self.contentView addSubview:self.shopAddress];
//        
//        [self.shopAddress mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.contentView);
//            make.top.equalTo(self.contentView.mas_centerY).offset(10);
//        }];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [UIView transitionWithView:self.shopName duration:.15 options:UIViewAnimationOptionCurveLinear animations:^{
        self.shopName.alpha = highlighted ? .5 : 1;
    } completion:nil];
}

- (void)setCellItem:(ActivityShopPreviewCellItem *)cellItem
{
    [super setCellItem:cellItem];
    self.shopName.text = cellItem.shop.shopname;
    self.shopAddress.text = cellItem.shop.address;
}

@end
