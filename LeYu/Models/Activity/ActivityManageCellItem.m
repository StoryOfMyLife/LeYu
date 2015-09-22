//
//  ActivityManageCellItem.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/21.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "ActivityManageCellItem.h"
#import "ActivityUserRelation.h"

@implementation ActivityManageCellItem

- (Class)cellClass
{
    return [ActivityManageCell class];
}

@end

@implementation ActivityManageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.imageIconView = [[UIImageView alloc] init];
        self.imageIconView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageIconView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageIconView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = DefaultTitleColor;
        self.titleLabel.font = SystemBoldFontWithSize(16);
        [self.contentView addSubview:self.titleLabel];
        
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.textColor = RGBCOLOR(120, 119, 116);
        self.dateLabel.font = SystemFontWithSize(13);
        [self.contentView addSubview:self.dateLabel];
        
        self.acceptedCount = [[UILabel alloc] init];
        self.acceptedCount.textColor = DefaultYellowColor;
        self.acceptedCount.font = SystemBoldFontWithSize(13);
        [self.contentView addSubview:self.acceptedCount];
        
        UIView *seperator = [[UIView alloc] init];
        seperator.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:seperator];
        
        CGFloat inset = 10;
        
        [self.imageIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(inset);
            make.top.equalTo(self.contentView).offset(inset);
            make.bottom.equalTo(self.contentView).offset(-inset);
            make.height.equalTo(@70);
            make.width.equalTo(@(70.0 * 16.0 / 10.0));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageIconView.mas_right).offset(inset * 2);
            make.right.equalTo(self.contentView).offset(- inset * 2);
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-inset);
        }];
        
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.contentView.mas_centerY).offset(inset);
        }];
        
        [self.acceptedCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.dateLabel);
            make.right.equalTo(self.contentView).offset(-inset);
        }];
        
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageIconView);
            make.height.mas_equalTo(0.5);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setCellItem:(ActivityManageCellItem *)cellItem
{
    [super setCellItem:cellItem];
    
    ShopActivities *activity = cellItem.activity;

    self.titleLabel.text = activity.title;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY.MM.dd  hh:mm";
    NSString *date = [formatter stringFromDate:activity.beginDate];
    self.dateLabel.text = date;

    AVQuery *relationQuery = [ActivityUserRelation query];
    [relationQuery whereKey:@"activity" equalTo:activity];
    
    [relationQuery countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        self.acceptedCount.text = [NSString stringWithFormat:@"%ld人参与", (long)number];
    }];
    
    [AVFile getFileWithObjectId:activity.pics[0] withBlock:^(AVFile *file, NSError *error) {
        [file getThumbnail:YES width:140 height:(140.0 * 16.0 / 9.0) withBlock:^(UIImage *image, NSError *error) {
            [UIView transitionWithView:self.imageIconView duration:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.imageIconView.image = image;
            } completion:nil];
        }];
    }];
}

@end
