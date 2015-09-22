//
//  MessageCellItem.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/23.
//  Copyright © 2015年 liuty. All rights reserved.
//

#import "MessageCellItem.h"

static CGFloat inset = 20;

@implementation MessageCellItem

- (Class)cellClass
{
    return [MessageCell class];
}

@end


@implementation MessageCell

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
        
        self.message = [[UILabel alloc] init];
        self.message.lineBreakMode = NSLineBreakByWordWrapping;
        self.message.numberOfLines = 0;
        self.message.preferredMaxLayoutWidth = SCREEN_WIDTH - 50 - inset * 3;
        self.message.font = SystemFontWithSize(13);
        self.message.textColor = RGBCOLOR(168, 168, 168);
        
        [self.contentView addSubview:self.message];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    [self.shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(inset);
        make.width.height.mas_equalTo(50);
        make.top.equalTo(self.contentView).offset(inset/2);
        make.bottom.equalTo(self.contentView).offset(-inset/2);
    }];
    
    [self.message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopIcon.mas_right).offset(inset);
        make.centerY.equalTo(self.shopIcon);
        make.right.equalTo(self.contentView).offset(-inset);
        make.top.greaterThanOrEqualTo(self.contentView).offset(inset/2);
        make.bottom.lessThanOrEqualTo(self.contentView).offset(-inset/2);
    }];
}

- (void)setCellItem:(MessageCellItem *)cellItem
{
    [super setCellItem:cellItem];
    Shop *shop = cellItem.activity.shop;
    
    self.message.text = [NSString stringWithFormat:@"您参与 @%@ 的活动马上就要开始了，赶快去参加哦!", shop.shopname];
    
    [shop.shopIcon getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
        [UIView transitionWithView:self.shopIcon duration:.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.shopIcon.image = image;
        } completion:nil];
    }];
}

@end
