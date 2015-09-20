//
//  ActivityAcceptCellItem.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/30.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ActivityAcceptCellItem.h"

static const CGFloat space = 25.0;

@implementation ActivityAcceptNameCellItem : LTableViewCellItem

- (Class)cellClass
{
    return [ActivityAcceptNameCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 52;
}

@end

@implementation ActivityAcceptNameCell : LTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.name = [[UITextField alloc] init];
        self.name.tintColor = DefaultYellowColor;
        self.name.placeholder = @"称呼";
        self.name.font = SystemFontWithSize(16);
        self.name.textColor = RGBCOLOR_HEX(0x646464);
        [self.contentView addSubview:self.name];
        
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(space);
            make.right.equalTo(self.contentView).offset(-space);
            make.centerY.equalTo(self.contentView);
        }];
        
        UIView *seperator = [[UIView alloc] init];
        seperator.backgroundColor = RGBCOLOR_HEX(0xe6e6e6);
        [self.contentView addSubview:seperator];
        
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(space);
            make.right.equalTo(self.contentView).offset(-space);
            make.height.equalTo(@1);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setCellItem:(ActivityAcceptNameCellItem *)cellItem
{
    [super setCellItem:cellItem];
}

@end

#pragma mark ---------------------------------------------

@implementation ActivityAcceptPhoneCellItem : LTableViewCellItem

- (Class)cellClass
{
    return [ActivityAcceptPhoneCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 52;
}

@end

@implementation ActivityAcceptPhoneCell : LTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.phone = [[UITextField alloc] init];
//        self.phone.tintColor = DefaultYellowColor;
        self.phone.placeholder = @"联系方式";
        self.phone.keyboardType = UIKeyboardTypeNumberPad;
        self.phone.font = SystemFontWithSize(16);
        self.phone.textColor = RGBCOLOR_HEX(0x646464);
        [self.contentView addSubview:self.phone];
        
        self.phone.text = [LYUser currentUser].mobilePhoneNumber;
        
        [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(space);
            make.right.equalTo(self.contentView).offset(-space);
            make.centerY.equalTo(self.contentView);
        }];
        
        UIView *seperator = [[UIView alloc] init];
        seperator.backgroundColor = RGBCOLOR_HEX(0xe6e6e6);
        [self.contentView addSubview:seperator];
        
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(space);
            make.right.equalTo(self.contentView).offset(-space);
            make.height.equalTo(@1);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setCellItem:(ActivityAcceptPhoneCellItem *)cellItem
{
    [super setCellItem:cellItem];
}

@end

#pragma mark ---------------------------------------------

@implementation ActivityAcceptDateDescCellItem : LTableViewCellItem

- (Class)cellClass
{
    return [ActivityAcceptDateDescCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 52;
}

@end

@implementation ActivityAcceptDateDescCell : LTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *title = [[UILabel alloc] init];
        title.font = SystemFontWithSize(16);
        title.textColor = RGBCOLOR_HEX(0x1f1f1f);
        title.text = @"到店时间";
        [self.contentView addSubview:title];
        
        UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        [self.contentView addSubview:indicator];
        
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.font = SystemFontWithSize(12);
        self.dateLabel.textColor = RGBCOLOR(130, 130, 130);
        [self.contentView addSubview:self.dateLabel];
        
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY.MM.dd  hh:mm";
        NSString *nowString = [formatter stringFromDate:now];
        self.dateLabel.text = nowString;
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(space);
            make.right.equalTo(self.contentView).offset(-space);
            make.centerY.equalTo(self.contentView);
        }];
        
        [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-space);
            make.centerY.equalTo(title);
        }];
        
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(indicator.mas_left).offset(-space / 2);
        }];
        
        UIView *seperator = [[UIView alloc] init];
        seperator.backgroundColor = RGBCOLOR_HEX(0xe6e6e6);
        [self.contentView addSubview:seperator];
        
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(space);
            make.right.equalTo(self.contentView).offset(-space);
            make.height.equalTo(@1);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setCellItem:(ActivityAcceptDateDescCellItem *)cellItem
{
    [super setCellItem:cellItem];
}

@end

#pragma mark ---------------------------------------------

@implementation ActivityAcceptDateCellItem : LTableViewCellItem

- (Class)cellClass
{
    return [ActivityAcceptDateCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 145;
}

@end

NSString * const kAcceptDatePickValueChanged = @"kAcceptDatePickValueChanged";

@implementation ActivityAcceptDateCell : LTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.datePicker.minimumDate = [NSDate date];
        [self.datePicker addTarget:self action:@selector(dateValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.datePicker];
        
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)dateValueChanged:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAcceptDatePickValueChanged object:sender];
}

@end

#pragma mark ---------------------------------------------

@implementation ActivityAcceptPreferenceCellItem : LTableViewCellItem

- (Class)cellClass
{
    return [ActivityAcceptPreferenceCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 180;
}

@end

@implementation ActivityAcceptPreferenceCell : LTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *title = [[UILabel alloc] init];
        title.text = @"个人偏好";
        title.font = SystemFontWithSize(16);
        title.textColor = RGBCOLOR_HEX(0x1f1f1f);
        [self.contentView addSubview:title];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(space);
            make.top.equalTo(self.contentView).offset(25);
        }];
        
        self.preference = [[GCPlaceholderTextView alloc] init];
        self.preference.delegate = self;
        self.preference.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.preference.backgroundColor = [UIColor clearColor];
        self.preference.tintColor = DefaultYellowColor;
        self.preference.textColor = RGBCOLOR_HEX(0xbebebe);
        self.preference.font = SystemFontWithSize(15);
        self.preference.placeholder = @"说点什么吧!";
        self.preference.placeholderColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.preference];
        
        self.preference.layer.borderColor = RGBCOLOR_HEX(0xd0d0d0).CGColor;
        self.preference.layer.borderWidth = 0.5;
        self.preference.layer.cornerRadius = 5;
        
        [self.preference mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(space);
            make.right.equalTo(self.contentView).offset(-space);
            make.top.equalTo(title.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView).offset(-space);
        }];
    }
    return self;
}

- (void)setCellItem:(ActivityAcceptPreferenceCellItem *)cellItem
{
    [super setCellItem:cellItem];
}

@end
