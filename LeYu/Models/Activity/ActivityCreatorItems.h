//
//  ActivityCreatorItems.h
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/15.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "LTableViewCellItem.h"

extern NSString * const kDatePickValueChanged;
extern NSString * const kAmountPickValueChanged;

@interface ActivityThemeCellItem : LTableViewCellItem

@property (nonatomic, copy) NSString *theme;

@end

@interface ActivityThemeCell : LTableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *theme;

@end

#pragma mark ---------------------------------------------

@interface ActivityPhotoCellItem : LTableViewCellItem

@end

@interface ActivityPhotoCell : LTableViewCell

@end

#pragma mark ---------------------------------------------

@interface ActivityShopNameCellItem : LTableViewCellItem

@property (nonatomic, copy) NSString *shopName;

@end

@interface ActivityShopNameCell : LTableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *shopThumbnail;

@end

#pragma mark ---------------------------------------------

@interface ActivityRecordCellItem : LTableViewCellItem

@property (nonatomic, assign) NSTimeInterval duration;

@end

@interface ActivityRecordCell : LTableViewCell

@property (nonatomic, strong) UILabel *descLabel;

@end

#pragma mark ---------------------------------------------

@interface ActivityDescriptionCellItem : LTableViewCellItem

@property (nonatomic, strong) NSString *desc;

@end

@interface ActivityDescriptionCell : LTableViewCell

@property (nonatomic, strong) UILabel *descLabel;

@end

#pragma mark ---------------------------------------------

@interface ActivityTimeCellItem : LTableViewCellItem

@end

@interface ActivityTimeCell : LTableViewCell

@property (nonatomic, strong) UILabel *timeLabel;

@end

#pragma mark ---------------------------------------------

@interface ActivityTimeSelectionCellItem : LTableViewCellItem

@end

@interface ActivityTimeSelectionCell : LTableViewCell

@property (nonatomic, strong) UIDatePicker *startDatePicker;

@end

#pragma mark ---------------------------------------------

@interface ActivityAmountCellItem : LTableViewCellItem

@end

@interface ActivityAmountCell : LTableViewCell

@property (nonatomic, strong) UILabel *amountLabel;

@end

#pragma mark ---------------------------------------------

@interface ActivityAmountSelectionCellItem : LTableViewCellItem

@end

@interface ActivityAmountSelectionCell : LTableViewCell

@property (nonatomic, strong) UIPickerView *amountPicker;

@end
