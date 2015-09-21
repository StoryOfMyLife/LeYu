//
//  ActivityAcceptedDetailCellItem.h
//  LeYu
//
//  Created by 刘廷勇 on 15/9/22.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "LTableViewCellItem.h"

@interface ActivityAcceptedDetailCellItem : LTableViewCellItem

@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) NSInteger count;

@end

@interface ActivityAcceptedDetailCell : LTableViewCell

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end