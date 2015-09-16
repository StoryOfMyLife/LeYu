//
//  LTableViewCell.m
//  LBase
//
//  Created by 刘廷勇 on 15/4/7.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "LTableViewCell.h"
#import "LTableViewCellItem.h"

@implementation UITableViewCell (reuse)

+ (id)dequeueCellForTableView:(UITableView *)tableView
{
    LTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (!cell) {
        cell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    return cell;
}

@end

@implementation LTableViewCell

- (CGFloat)tableView:(UITableView *)tableView heightForItem:(LTableViewCellItem *)item
{
    return 44;
}

@end
