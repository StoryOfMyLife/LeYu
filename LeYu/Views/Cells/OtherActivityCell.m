//
//  OtherActivityCellItem.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/9/7.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "OtherActivityCell.h"
#import "ShopActivities.h"

@implementation OtherActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
//        self.layer.shadowOffset = CGSizeMake(0, 0);
//        self.layer.shadowOpacity = 1;
//        self.layer.shadowRadius = 3;
        
        self.imageIconView = [[UIImageView alloc] init];
        self.imageIconView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageIconView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageIconView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = RGBCOLOR(111, 111, 111);
        self.titleLabel.font = SystemFontWithSize(13);
        [self.contentView addSubview:self.titleLabel];
        
        CGFloat inset = 10;
        
        [self.imageIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(inset * 2);
            make.top.equalTo(self.contentView).offset(inset);
            make.bottom.equalTo(self.contentView).offset(-inset);
            make.height.equalTo(@70);
            make.width.equalTo(@(70.0 * 16.0 / 9.0));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageIconView.mas_right).offset(inset * 2);
            make.right.equalTo(self.contentView).offset(- inset * 2);
            make.top.equalTo(self.imageIconView);
        }];
    }
    return self;
}

- (void)setCellItem:(ShopActivities *)cellItem
{
    [super setCellItem:cellItem];
    self.titleLabel.text = cellItem.activitiesDescription;
    [AVFile getFileWithObjectId:cellItem.pics[0] withBlock:^(AVFile *file, NSError *error) {
        [file getThumbnail:YES width:70 height:(70.0 * 16.0 / 9.0) withBlock:^(UIImage *image, NSError *error) {
            [UIView transitionWithView:self.imageIconView duration:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.imageIconView.image = image;
            } completion:nil];
        }];
    }];
}

@end