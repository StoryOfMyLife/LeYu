//  ActivityCreatorItems.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/15.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ActivityCreatorItems.h"
#import "ImageAssetsManager.h"

static const CGFloat space = 10.0;
static const NSInteger countPerLine = 4;

@implementation ActivityThemeCellItem

- (Class)cellClass
{
    return [ActivityThemeCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 63;
}

@end

@implementation ActivityThemeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = [UIColor clearColor];
        
        self.theme = [[UITextField alloc] init];
        self.theme.delegate = self;
        self.theme.tintColor = DefaultYellowColor;
        self.theme.placeholder = @"请输入主题";
        self.theme.font = SystemFontWithSize(15);
        [self.contentView addSubview:self.theme];
        
//        UILabel *numberLabel = [[UILabel alloc] init];
//        numberLabel.textAlignment = NSTextAlignmentRight;
//        numberLabel.textColor = RGBCOLOR_HEX(0xb4b4b4);
//        numberLabel.font = SystemFontWithSize(10);
//        [self.contentView addSubview:numberLabel];
//        
//        [[self.theme.rac_textSignal map:^id(NSString *text) {
//            return @(text.length)
//            ;
//        }] subscribeNext:^(NSNumber *length) {
//            numberLabel.text = [NSString stringWithFormat:@"%ld/16", (long)length.integerValue];
//        }];
//        
//        [[RACObserve(self.theme, text) map:^id(NSString *text) {
//            return @(text.length);
//        }] subscribeNext:^(NSNumber *length) {
//            numberLabel.text = [NSString stringWithFormat:@"%ld/16", (long)length.integerValue];
//        }];
        
        
//        UIView *seperator = [[UIView alloc] init];
//        seperator.backgroundColor = [UIColor blackColor];
//        [self.contentView addSubview:seperator];
        
        [self.theme mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView);
        }];
        
//        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.contentView).offset(-8);
//            make.right.equalTo(self.theme);
//        }];
        
//        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.and.right.equalTo(self.theme);
//            make.height.equalTo(@0.5);
//            make.bottom.equalTo(self.contentView);
//        }];
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(range.length + range.location > textField.text.length) {
        return NO;
    }
    
//    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return YES;//newLength <= 16 || [string isEqualToString:@""];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [ImageAssetsManager manager].activityTheme = textField.text;
}

- (void)setCellItem:(ActivityThemeCellItem *)cellItem
{
    [super setCellItem:cellItem];
}

@end

#pragma mark ---------------------------------------------

@implementation ActivityPhotoCellItem

- (Class)cellClass
{
    return [ActivityPhotoCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    NSArray *assets = [[ImageAssetsManager manager] allAssets];
    CGFloat oneRowWidth = (SCREEN_WIDTH - (countPerLine + 1) * space) / countPerLine;
    CGFloat oneRowHeight = oneRowWidth * 3.0 / 4.0;
    if (assets.count > 4) {
        return oneRowHeight * 2 + space * 3;
    } else {
        return oneRowHeight + space * 2;
    }
}

@end

@implementation ActivityPhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:containerView];
//        self.backgroundColor = [UIColor clearColor];
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        
        NSArray *images = [[ImageAssetsManager manager] allClippedImages];
        
        for (NSInteger i = 0; i < images.count; i++) {
            NSInteger row = i / countPerLine;
            NSInteger col = i % countPerLine;
            
            UIImage *image = images[i];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            
            CGFloat itemWidth = (SCREEN_WIDTH - (countPerLine + 1) * space) / countPerLine;
            CGSize itemSize = CGSizeMake(itemWidth, itemWidth * 3.0 / 4.0);
            
            CGPoint itemOrigin = CGPointMake((itemSize.width + space) * col, (itemSize.height + space) * row);
            
            [containerView addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo([NSValue valueWithCGSize:itemSize]);
                make.left.equalTo(@(itemOrigin.x));
                make.top.equalTo(@(itemOrigin.y));
            }];
        }
        
//        UIView *seperator = [[UIView alloc] init];
//        seperator.backgroundColor = [UIColor blackColor];
//        [self addSubview:seperator];
//        
//        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.and.right.equalTo(containerView);
//            make.height.equalTo(@0.5);
//            make.bottom.equalTo(self);
//        }];
    }
    return self;
}

- (void)setCellItem:(ActivityThemeCellItem *)cellItem
{
    [super setCellItem:cellItem];
}

@end

#pragma mark ---------------------------------------------

@implementation ActivityShopNameCellItem

- (Class)cellClass
{
    return [ActivityShopNameCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 45;
}

@end

@implementation ActivityShopNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = RGBCOLOR_HEX(0xf7f7f7);
        UILabel *atLabel = [[UILabel alloc] init];
        atLabel.text = @"@";
        atLabel.textColor = DefaultYellowColor;
        [self.contentView addSubview:atLabel];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = SystemFontWithSize(16);
        [self.contentView addSubview:self.nameLabel];
        
        [atLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(atLabel);
            make.left.equalTo(atLabel.mas_right).offset(5);
            make.right.lessThanOrEqualTo(self.contentView).offset(-10);
        }];
    }
    return self;
}

- (void)setCellItem:(ActivityShopNameCellItem *)cellItem
{
    [super setCellItem:cellItem];
    self.nameLabel.text = cellItem.shopName;
}

@end

#pragma mark ---------------------------------------------

@implementation ActivityRecordCellItem

- (Class)cellClass
{
    return [ActivityRecordCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 45;
}

- (void)setDuration:(NSTimeInterval)duration
{
    _duration = duration;
    [self.cell setCellItem:self];
}

@end

@implementation ActivityRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *title = [[UILabel alloc] init];
        title.text = @"店家录音";
        title.textColor = [UIColor blackColor];
        title.font = SystemFontWithSize(16);
        [self.contentView addSubview:title];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(space);
        }];
        
        self.descLabel = [[UILabel alloc] init];
        self.descLabel.textAlignment = NSTextAlignmentRight;
        self.descLabel.font = SystemFontWithSize(12);
        self.descLabel.textColor = RGBCOLOR(130, 130, 130);
        [self.contentView addSubview:self.descLabel];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setCellItem:(ActivityRecordCellItem *)cellItem
{
    [super setCellItem:cellItem];
    NSTimeInterval duration = cellItem.duration;
    if (duration > 0) {
        self.descLabel.text = [NSString stringWithFormat:@"%.fs", duration];
    } else {
        self.descLabel.text = @"未录音";
    }
}

@end

#pragma mark ---------------------------------------------

@implementation ActivityDescriptionCellItem

- (Class)cellClass
{
    return [ActivityDescriptionCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 45;
}

@end

@interface ActivityDescriptionCell () <UITextViewDelegate>

@end

@implementation ActivityDescriptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel *title = [[UILabel alloc] init];
        title.text = @"内容说明";
        title.font = SystemFontWithSize(15);
        title.textColor = [UIColor blackColor];
        [self.contentView addSubview:title];
        
        self.descLabel = [[UILabel alloc] init];
        self.descLabel.textAlignment = NSTextAlignmentRight;
        self.descLabel.font = SystemFontWithSize(12);
        self.descLabel.textColor = RGBCOLOR(130, 130, 130);
        self.descLabel.text = @"未填写";
        [self.contentView addSubview:self.descLabel];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
        
//        self.descriptionView = [[UITextView alloc] init];
//        self.descriptionView.delegate = self;
//        self.descriptionView.scrollEnabled = NO;
//        self.descriptionView.tintColor = DefaultYellowColor;
//        self.descriptionView.font = SystemFontWithSize(12);
//        self.descriptionView.textColor = RGBCOLOR(130, 130, 130);
//        [self.contentView addSubview:self.descriptionView];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(space);
        }];
        
//        [self.descriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(title.mas_right).offset(space);
//            make.right.lessThanOrEqualTo(self.contentView).offset(-space);
//            make.top.equalTo(self.contentView).offset(space/2);
//            make.bottom.equalTo(self.contentView).offset(-space/2);
//        }];
        
//        UIView *seperator = [[UIView alloc] init];
//        seperator.backgroundColor = RGBCOLOR_HEX(0xe6e6e6);
//        [self addSubview:seperator];
//        
//        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(space);
//            make.right.equalTo(self).offset(-space);
//            make.height.equalTo(@1);
//            make.bottom.equalTo(self.contentView);
//        }];
    }
    return self;
}

@end

#pragma mark ---------------------------------------------

@implementation ActivityTimeCellItem

- (Class)cellClass
{
    return [ActivityTimeCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 45;
}

@end

@implementation ActivityTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.contentView.userInteractionEnabled = YES;
        UILabel *title = [[UILabel alloc] init];
        title.userInteractionEnabled = NO;
        title.text = @"截止日期";
        title.font = SystemFontWithSize(15);
        title.textColor = [UIColor blackColor];
        [self.contentView addSubview:title];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.userInteractionEnabled = NO;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.font = SystemFontWithSize(12);
        self.timeLabel.textColor = RGBCOLOR(130, 130, 130);
        [self.contentView addSubview:self.timeLabel];
        
//        NSDate *now = [NSDate date];
//        NSDate *weekFromNow = [now dateByAddingTimeInterval:aDay * 30];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"YYYY.MM.dd";
//        NSString *nowString = [formatter stringFromDate:now];
//        NSString *weekFromNowString = [formatter stringFromDate:weekFromNow];
        self.timeLabel.text = @"无限制";
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(space);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
        
//        UIView *seperator = [[UIView alloc] init];
//        seperator.backgroundColor = RGBCOLOR_HEX(0xe6e6e6);
//        [self addSubview:seperator];
//        
//        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(space);
//            make.right.equalTo(self).offset(-space);
//            make.height.equalTo(@1);
//            make.bottom.equalTo(self.contentView);
//        }];
    }
    return self;
}

- (void)setCellItem:(ActivityTimeCellItem *)cellItem
{
    [super setCellItem:cellItem];
}

@end

#pragma mark ---------------------------------------------

@implementation ActivityTimeSelectionCellItem

- (Class)cellClass
{
    return [ActivityTimeSelectionCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 145;
}

@end

NSString * const kDatePickValueChanged = @"kDatePickValueChanged";

@implementation ActivityTimeSelectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.startDatePicker = [[UIDatePicker alloc] init];
        self.startDatePicker.datePickerMode = UIDatePickerModeDate;
        self.startDatePicker.minimumDate = [NSDate date];
        [self.startDatePicker addTarget:self action:@selector(dateValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.startDatePicker];
        
        [self.startDatePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)dateValueChanged:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDatePickValueChanged object:sender];
}

@end

#pragma mark ---------------------------------------------

@implementation ActivityAmountCellItem

- (Class)cellClass
{
    return [ActivityAmountCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 45;
}

@end

@implementation ActivityAmountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *title = [[UILabel alloc] init];
        title.text = @"参与人数";
        title.font = SystemFontWithSize(15);
        title.textColor = [UIColor blackColor];
        [self.contentView addSubview:title];
        
        self.amountLabel = [[UILabel alloc] init];
        self.amountLabel.textAlignment = NSTextAlignmentRight;
        self.amountLabel.font = SystemFontWithSize(12);
        self.amountLabel.textColor = RGBCOLOR(130, 130, 130);
        self.amountLabel.text = @"无限制";
        [self.contentView addSubview:self.amountLabel];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(space);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
        
//        UIView *seperator = [[UIView alloc] init];
//        seperator.backgroundColor = RGBCOLOR_HEX(0xe6e6e6);
//        [self addSubview:seperator];
//        
//        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self).offset(space);
//            make.right.equalTo(self).offset(-space);
//            make.height.equalTo(@1);
//            make.bottom.equalTo(self.contentView);
//        }];
    }
    return self;
}

- (void)setCellItem:(ActivityAmountCellItem *)cellItem
{
    [super setCellItem:cellItem];
}

@end

#pragma mark ---------------------------------------------

@implementation ActivityAmountSelectionCellItem

- (Class)cellClass
{
    return [ActivityAmountSelectionCell class];
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    return 145;
}

@end

NSString * const kAmountPickValueChanged = @"kAmountPickValueChanged";

@interface ActivityAmountSelectionCell () <UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation ActivityAmountSelectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.amountPicker = [[UIPickerView alloc] init];
        self.amountPicker.delegate = self;
        self.amountPicker.dataSource = self;
        self.amountPicker.showsSelectionIndicator = YES;
        [self.amountPicker selectRow:4 inComponent:0 animated:YES];
        [self.contentView addSubview:self.amountPicker];
        
        [self.amountPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10 + 1;
}

#pragma mark - delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"无限制";
    }
    return [NSString stringWithFormat:@"%ld", (long)row * 10];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *amount = [self pickerView:pickerView titleForRow:row forComponent:component];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAmountPickValueChanged object:amount];
}

@end
