//
//  LTableViewCellItem.h
//  LBase
//
//  Created by 刘廷勇 on 15/4/7.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "LTableViewCell.h"

typedef void(^ActionBlock)(UITableView *tableView, NSIndexPath *indexPath);
typedef void(^HandleBlock)(NSDictionary *info);

@interface LTableViewCellItem : AVObject <AVSubclassing>

@property (nonatomic, copy) ActionBlock actionBlock; // for cell selection

@property (nonatomic, copy) HandleBlock handleBlock; // for cell button

@property (nonatomic, weak) LTableViewCell *cell;

- (Class)cellClass;

- (void)applyActionBlock:(ActionBlock)actionBlock;

- (CGFloat)heightForTableView:(UITableView *)tableView;

@end
