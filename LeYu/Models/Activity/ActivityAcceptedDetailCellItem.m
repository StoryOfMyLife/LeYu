//
//  ActivityAcceptedDetailCellItem.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/22.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "ActivityAcceptedDetailCellItem.h"

@implementation ActivityAcceptedDetailCellItem

- (Class)cellClass
{
    return [ActivityAcceptedDetailCell class];
}

@end


@implementation ActivityAcceptedDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.font = SystemFontWithSize(15);
        self.dateLabel.textColor = DefaultTitleColor;
        [self.contentView addSubview:self.dateLabel];
        
        self.countLabel = [[UILabel alloc] init];
        self.countLabel.font = SystemFontWithSize(15);
        self.countLabel.textAlignment = NSTextAlignmentRight;
        self.countLabel.textColor = DefaultTitleColor;
        [self.contentView addSubview:self.countLabel];
        
        CGFloat inset = 40;
        
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(inset);
            make.top.equalTo(self.contentView).offset(inset/2);
            make.bottom.equalTo(self.contentView).offset(-inset/2);
        }];
        
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLabel);
            make.right.equalTo(self.contentView).offset(-inset);
        }];
    }
    return self;
}

- (void)setCellItem:(ActivityAcceptedDetailCellItem *)cellItem
{
    [super setCellItem:cellItem];
    self.dateLabel.text = cellItem.date;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)cellItem.count];
}

@end
