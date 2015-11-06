//
//  ActivityDetailCellItem.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/29.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ActivityDetailCellItem.h"

@implementation ActivityDetailCellItem

- (Class)cellClass
{
    return [ActivityDetailCell class];
}

@end

@interface ActivityDetailCell ()

@property (nonatomic, strong) UIView *descLine;

@end

@implementation ActivityDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *timeLine = [[UIView alloc] init];
        timeLine.backgroundColor = DefaultYellowColor;
        [self.contentView addSubview:timeLine];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = SystemFontWithSize(16);
        timeLabel.textColor = DefaultYellowColor;
        timeLabel.text = @"时间";
        [self.contentView addSubview:timeLabel];
        
        self.activityDateLabel = [[UILabel alloc] init];
        self.activityDateLabel.font = self.activityDescLabel.font;
        self.activityDateLabel.textColor = self.activityDescLabel.textColor;
        [self.contentView addSubview:self.activityDateLabel];
        
        [RACObserve(self.activityDateLabel, hidden) subscribeNext:^(NSNumber *hidden) {
            timeLabel.hidden = [hidden boolValue];
            timeLine.hidden = [hidden boolValue];
        }];
        
        self.descLine = [[UIView alloc] init];
        self.descLine.backgroundColor = DefaultYellowColor;
        [self.contentView addSubview:self.descLine];
        
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.font = SystemFontWithSize(16);
        descLabel.textColor = DefaultYellowColor;
        descLabel.text = @"说明";
        [self.contentView addSubview:descLabel];
        
        self.activityDescLabel = [[UILabel alloc] init];
//        self.activityDescLabel.font = SystemFontWithSize(16);
        self.activityDescLabel.textColor = RGBCOLOR_HEX(0x828282);
        self.activityDescLabel.numberOfLines = 0;
        self.activityDescLabel.textAlignment = NSTextAlignmentNatural;
        self.activityDescLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.activityDescLabel.preferredMaxLayoutWidth = self.contentView.width - 20 * 2;
        [self.contentView addSubview:self.activityDescLabel];
        
        self.likeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.likeButton.tintColor = DefaultYellowColor;
        self.likeButton.titleLabel.font = SystemFontWithSize(10);
        self.likeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.likeButton setImage:[UIImage imageNamed:@"Praise"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.likeButton];
        
        UIView *bottomSeperator = [[UIView alloc] init];
        bottomSeperator.backgroundColor = RGBCOLOR(205, 205, 205);
        [self.contentView addSubview:bottomSeperator];
        
//        UIView *buttonContainer = [[UIView alloc] init];
//        buttonContainer.backgroundColor = [UIColor clearColor];
//        buttonContainer.layer.borderColor = DefaultYellowColor.CGColor;
//        buttonContainer.layer.borderWidth = 1;
//        buttonContainer.layer.cornerRadius = 2;
//        [self.contentView addSubview:buttonContainer];
//        
//        self.acceptButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        [self.acceptButton addTarget:self action:@selector(pressedAcceptButton:) forControlEvents:UIControlEventTouchUpInside];
//        [self.acceptButton setTitle:@"接受" forState:UIControlStateNormal];
//        self.acceptButton.titleLabel.font = SystemFontWithSize(16);
//        self.acceptButton.tintColor = DefaultYellowColor;
//        [buttonContainer addSubview:self.acceptButton];
//        
//        UIView *verticalLine2 = [[UIView alloc] init];
//        verticalLine2.backgroundColor = DefaultYellowColor;
//        [buttonContainer addSubview:verticalLine2];
//        
//        UIImageView *giftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Package"]];
//        [buttonContainer addSubview:giftView];
//        
//        self.giftLabel = [[UILabel alloc] init];
//        self.giftLabel.textAlignment = NSTextAlignmentRight;
//        self.giftLabel.font = SystemFontWithSize(14);
//        self.giftLabel.textColor = DefaultYellowColor;
//        [buttonContainer addSubview:self.giftLabel];
        
        [timeLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(timeLabel);
            make.width.equalTo(@1);
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.contentView).offset(30);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeLine);
            make.left.equalTo(timeLine.mas_right).offset(10);
        }];
        
        [self.activityDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(timeLine);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(timeLine.mas_bottom).offset(10);
        }];
        
        [self.descLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(descLabel);
            make.width.equalTo(@1);
            make.left.equalTo(timeLine);
            make.top.equalTo(self.activityDateLabel.mas_bottom).offset(35);
        }];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.descLine);
            make.left.equalTo(timeLabel);
        }];
        
        [self.activityDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.activityDateLabel);
            make.right.equalTo(self.activityDateLabel);
            make.top.equalTo(self.descLine.mas_bottom).offset(10);
        }];
        
        [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.activityDescLabel.mas_bottom).offset(25);
            make.bottom.equalTo(bottomSeperator).offset(-50);
        }];
        
        [bottomSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.height.equalTo(@0.5);
            make.width.equalTo(self.contentView).offset(-30);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
        
//        [buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.likeButton);
//            make.width.equalTo(@115);
//            make.height.equalTo(@34);
//            make.right.equalTo(self.contentView).offset(-10);
//        }];
//        
//        [self.acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(buttonContainer).multipliedBy(0.5);
//            make.centerY.equalTo(buttonContainer);
//        }];
//        
//        [verticalLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(buttonContainer);
//            make.height.equalTo(buttonContainer.mas_height).multipliedBy(0.5);
//            make.width.equalTo(@1);
//        }];
//        
//        [giftView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(verticalLine2).offset(12);
//            make.centerY.equalTo(verticalLine2);
//        }];
//        [self.giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.acceptButton);
//            make.right.equalTo(buttonContainer).offset(-12);
//        }];
    }
    return self;
}

- (void)setCellItem:(ActivityDetailCellItem *)cellItem
{
    [super setCellItem:cellItem];
    
    ShopActivities *activity = cellItem.activity;
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 10;
    paragraph.firstLineHeadIndent = 32;
    
    NSString *desc = activity.activitiesDescription;
    if (!desc) {
        desc = @"没有说明";
    }
    NSAttributedString *aStr = [[NSAttributedString alloc] initWithString:desc
                                                               attributes:@{NSFontAttributeName : SystemFontWithSize(16),
                                                                            NSKernAttributeName : @(0),
                                                                            NSParagraphStyleAttributeName : paragraph}];
    self.activityDescLabel.attributedText = aStr;
//    self.activityDescLabel.text = activity.activitiesDescription;
    [self.likeButton setTitle:[activity.likes stringValue] ?: @"0" forState:UIControlStateNormal];
    [self layoutButton:self.likeButton];
    
    NSDate *beginDate = cellItem.activity.beginDate;
    NSDate *endDate = cellItem.activity.endDate;
    if (endDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY.MM.dd";
        NSString *beginDateString = [formatter stringFromDate:beginDate];
        NSString *endDateString = [formatter stringFromDate:endDate];
        self.activityDateLabel.text = [NSString stringWithFormat:@"%@ - %@", beginDateString, endDateString];
        [self.descLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.activityDateLabel.mas_bottom).offset(35);
        }];
        self.activityDateLabel.hidden = NO;
    } else {
        self.activityDateLabel.text = @"无限制";
        self.activityDateLabel.hidden = YES;
        [self.descLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(30);
        }];
    }
    
    
    weakSelf();
    [[self.likeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        weakSelf.likeButton.userInteractionEnabled = NO;
        [weakSelf.likeButton setImage:[UIImage imageNamed:@"Praise_highlighted"] forState:UIControlStateNormal];
        activity.fetchWhenSave = YES;
        [activity incrementKey:@"likes"];
        [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [weakSelf.likeButton setTitle:[activity.likes stringValue] forState:UIControlStateNormal];
            [weakSelf layoutButton:weakSelf.likeButton];
        }];
    }];
}

//此方法引起constraints冲突警告，没影响，暂时不用管
- (void)layoutButton:(UIButton *)button
{
    CGSize imageSize = button.imageView.image.size;
    CGSize titleSize = button.titleLabel.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0,
                                              - (imageSize.width + titleSize.width),
                                              - (imageSize.height / 2),
                                              0.0);
}

#pragma mark -
#pragma mark accept button delegate

- (void)pressedAcceptButton:(UIButton *)button
{
    if (self.cellItem.handleBlock) {
        self.cellItem.handleBlock(@{@"sender" : button, @"description" : @"Accept button pressed."});
    }
}

@end
