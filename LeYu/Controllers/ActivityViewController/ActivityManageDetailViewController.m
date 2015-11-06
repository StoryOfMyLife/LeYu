//
//  ActivityManageDetailViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/22.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "ActivityManageDetailViewController.h"
#import "ActivityAcceptedDetailCellItem.h"
#import "ActivityAcceptedMoreDetailCellItem.h"
#import "ActivityUserRelation.h"

@interface ActivityManageDetailViewController ()

@end

@implementation ActivityManageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"参与详情";
    
    self.tableView.backgroundColor = DefaultBackgroundColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = [self tableHeadView];
    self.refreshEnable = NO;
    
    AVQuery *relationQuery = [ActivityUserRelation query];
    [relationQuery whereKey:@"activity" equalTo:self.activity];
    
    [relationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        NSMutableDictionary *arriveDateDic = [NSMutableDictionary dictionary];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy/mm/dd";
        
        for (ActivityUserRelation *relation in objects) {
            NSDate *date = relation.userArriveDate;
            NSString *dateString = [formatter stringFromDate:date];
            
            NSArray *users = arriveDateDic[dateString];
            NSMutableArray *mutableUsers;
            
            if (users) {
                mutableUsers = [NSMutableArray arrayWithArray:users];
            } else {
                mutableUsers = [NSMutableArray arrayWithCapacity:0];
            }
            
            [mutableUsers addObject:relation];
            
            arriveDateDic[dateString] = mutableUsers;
        }
        
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
        for (NSString *date in [arriveDateDic allKeys]) {
            NSArray *relations = arriveDateDic[date];
            
            ActivityAcceptedDetailCellItem *item = [[ActivityAcceptedDetailCellItem alloc] init];
            [item applyActionBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
                
                [tableView beginUpdates];
                
                NSArray *currentItems = self.items[indexPath.section];
                
                NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *moreDetailItems = [NSMutableArray arrayWithCapacity:0];
                NSInteger row = indexPath.row;
                NSInteger section = indexPath.section;
                for (ActivityUserRelation *relation in relations) {
                    row++;
                    [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
                    ActivityAcceptedMoreDetailCellItem *moreItem = [[ActivityAcceptedMoreDetailCellItem alloc] init];
                    moreItem.relation = relation;
                    [moreDetailItems addObject:moreItem];
                }
                
                if ([currentItems count] == 1) {
                    //未展开，现在展开
                    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                    
                    NSMutableArray *newSectionItems = [NSMutableArray arrayWithArray:self.items[indexPath.section]];
                    [newSectionItems addObjectsFromArray:moreDetailItems];
                    
                    NSMutableArray *newItems = [NSMutableArray arrayWithArray:self.items];
                    [newItems replaceObjectAtIndex:indexPath.section withObject:newSectionItems];
                    [self _setItems:newItems];
                    
                } else {
                    //已展开，现在收起
                    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                    
                    NSMutableArray *newSectionItems = [NSMutableArray arrayWithArray:self.items[indexPath.section]];
                    newSectionItems = [NSMutableArray arrayWithObject:newSectionItems[0]];
                    NSMutableArray *newItems = [NSMutableArray arrayWithArray:self.items];
                    [newItems replaceObjectAtIndex:indexPath.section withObject:newSectionItems];
                    [self _setItems:newItems];
                }
                [tableView endUpdates];
            }];
            item.date = date;
            item.count = [relations count];
            [items addObject:@[item]];
        }
        self.items = items;
    }];
}

- (UIView *)tableHeadView
{
    UIView *view = [[UIView alloc] init];
    
    view.width = self.view.width;
    view.height = 50;
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *dateImage = [[UIImageView alloc] init];
    dateImage.contentMode = UIViewContentModeScaleAspectFill;
    dateImage.clipsToBounds = YES;
    dateImage.image = [UIImage imageNamed:@"日期"];
    [view addSubview:dateImage];
    
    UILabel *date = [[UILabel alloc] init];
    date.font = SystemFontWithSize(15);
    date.textColor = DefaultTitleColor;
    date.text = @"到店时间";
    [view addSubview:date];
    
    UIImageView *countImage = [[UIImageView alloc] init];
    countImage.contentMode = UIViewContentModeScaleAspectFill;
    countImage.clipsToBounds = YES;
    countImage.image = [UIImage imageNamed:@"用户"];
    [view addSubview:countImage];
    
    UILabel *count = [[UILabel alloc] init];
    count.font = SystemFontWithSize(15);
    count.textColor = DefaultTitleColor;
    count.text = @"用户数";
    [view addSubview:count];
    
    [dateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(40);
        make.width.height.mas_equalTo(30);
    }];
    
    [date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(dateImage.mas_right).offset(5);
    }];
    
    [count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.right.equalTo(view).offset(-40);
    }];
    
    [countImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(count.mas_left).offset(-5);
        make.centerY.equalTo(view);
        make.width.height.mas_equalTo(30);
    }];
    
    return view;
}

@end
