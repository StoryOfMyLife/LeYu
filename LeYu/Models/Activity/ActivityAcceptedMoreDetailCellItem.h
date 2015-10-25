//
//  ActivityAcceptedMoreDetailCellItem.h
//  LeYu
//
//  Created by 刘廷勇 on 15/10/25.
//  Copyright © 2015年 liuty. All rights reserved.
//

#import "LTableViewCellItem.h"
#import "ActivityUserRelation.h"

@interface ActivityAcceptedMoreDetailCellItem : LTableViewCellItem

@property (nonatomic, strong) ActivityUserRelation *relation;

@end

@interface ActivityAcceptedMoreDetailCell : LTableViewCell

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *checkButton;

@end
