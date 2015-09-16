//
//  ActivityAcceptCellItem.h
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/30.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "LTableViewCellItem.h"
#import "GCPlaceholderTextView.h"

extern NSString * const kAcceptDatePickValueChanged;

@interface ActivityAcceptNameCellItem : LTableViewCellItem

@end

@interface ActivityAcceptNameCell : LTableViewCell

@property (nonatomic, strong) UITextField *name;

@end

#pragma mark ---------------------------------------------

@interface ActivityAcceptPhoneCellItem : LTableViewCellItem

@end

@interface ActivityAcceptPhoneCell : LTableViewCell

@property (nonatomic, strong) UITextField *phone;

@end

#pragma mark ---------------------------------------------

@interface ActivityAcceptDateDescCellItem : LTableViewCellItem

@end

@interface ActivityAcceptDateDescCell : LTableViewCell

@property (nonatomic, strong) UILabel *dateLabel;

@end

#pragma mark ---------------------------------------------

@interface ActivityAcceptDateCellItem : LTableViewCellItem

@end

@interface ActivityAcceptDateCell : LTableViewCell

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

#pragma mark ---------------------------------------------

@interface ActivityAcceptPreferenceCellItem : LTableViewCellItem

@end

@interface ActivityAcceptPreferenceCell : LTableViewCell <UITextViewDelegate>

@property (nonatomic, strong) GCPlaceholderTextView *preference;

@end