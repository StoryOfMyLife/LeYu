//
//  LTableViewDelegate.h
//  LBase
//
//  Created by 刘廷勇 on 15/4/7.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LTableViewDelegate <NSObject>

- (id)tableView:(UITableView *)tableView itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didSelectItem:(id)item atIndexPath:(NSIndexPath *)indexPath;

@end
