//
//  LTableViewCellItem.m
//  LBase
//
//  Created by 刘廷勇 on 15/4/7.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "LTableViewCellItem.h"
#import "LTableViewCell.h"

@implementation LTableViewCellItem

- (Class)cellClass
{
    return [LTableViewCell class];
}

- (void)applyActionBlock:(ActionBlock)actionBlock
{
    self.actionBlock = actionBlock;
}

- (CGFloat)heightForTableView:(UITableView *)tableView
{
    CGFloat height = [self.cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

@end
