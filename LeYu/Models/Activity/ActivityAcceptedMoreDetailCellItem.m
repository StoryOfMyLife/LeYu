//
//  ActivityAcceptedMoreDetailCellItem.m
//  LeYu
//
//  Created by 刘廷勇 on 15/10/25.
//  Copyright © 2015年 liuty. All rights reserved.
//

#import "ActivityAcceptedMoreDetailCellItem.h"

@implementation ActivityAcceptedMoreDetailCellItem

- (Class)cellClass
{
    return [ActivityAcceptedMoreDetailCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 60;
}

- (ActivityUserRelation *)relation
{
    if (!_relation.user.thumbnail) {
        AVQuery *userQuery = [LYUser query];
        _relation.user = (LYUser *)[userQuery getObjectWithId:_relation.user.objectId];
    }
    return _relation;
}

@end

@implementation ActivityAcceptedMoreDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat inset = 40;
        
        UIView *indicator = [[UIView alloc] init];
        indicator.backgroundColor = DefaultYellowColor;
        [self.contentView addSubview:indicator];
        
        [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.height.equalTo(self.contentView);
            make.width.mas_equalTo(5);
        }];
        
        self.avatar = [[UIImageView alloc] init];
        self.avatar.contentMode = UIViewContentModeScaleAspectFill;
        self.avatar.clipsToBounds = YES;
        self.avatar.layer.cornerRadius = 20;
        [self.contentView addSubview:self.avatar];
        
        [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(inset);
            make.height.width.equalTo(@(inset));
        }];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = SystemFontWithSize(15);
        self.nameLabel.textColor = DefaultTitleColor;
        [self.contentView addSubview:self.nameLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.avatar.mas_right).offset(inset/4);
        }];
        
        self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.checkButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.checkButton];
        
        [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-inset);
        }];
    }
    return self;
}

- (void)setCheckButtonStatus:(BOOL)arrived
{
    if (arrived) {
        [self.checkButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    } else {
        [self.checkButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    }
}

- (void)setCellItem:(ActivityAcceptedMoreDetailCellItem *)cellItem
{
    [super setCellItem:cellItem];
    
    [self setCheckButtonStatus:cellItem.relation.isArrived];
    
    @weakify(self);
    [[self.checkButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        cellItem.relation.isArrived = !cellItem.relation.isArrived;
        [self setCheckButtonStatus:cellItem.relation.isArrived];
        [cellItem.relation save];
    }];
    
    [cellItem.relation.user.thumbnail getThumbnail:YES width:80 height:80 withBlock:^(UIImage *image, NSError *error) {
        [UIView transitionWithView:self.avatar duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.avatar.image = image;
        } completion:nil];
    }];
    
    self.nameLabel.text = cellItem.relation.user.username;
}

@end
