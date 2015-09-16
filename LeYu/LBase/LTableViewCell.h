//
//  LTableViewCell.h
//  LBase
//
//  Created by 刘廷勇 on 15/4/7.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTableViewCellItem;

@interface UITableViewCell (reuse)

+ (id)dequeueCellForTableView:(UITableView *)tableView;

@end

@interface LTableViewCell : UITableViewCell

@property (nonatomic, strong) LTableViewCellItem *cellItem;

@property (nonatomic, weak) UITableView *tableView;

- (CGFloat)tableView:(UITableView *)tableView heightForItem:(LTableViewCellItem *)item;

@end
