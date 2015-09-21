//
//  ActivityManageDetailViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/22.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "ActivityManageDetailViewController.h"
#import "ActivityAcceptedDetailCellItem.h"
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

        NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
        NSMutableDictionary *arriveDateDic = [NSMutableDictionary dictionary];
        for (ActivityUserRelation *relation in objects) {
            NSDate *date = relation.userArriveDate;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy/mm/dd";
            NSString *dateString = [formatter stringFromDate:date];
            
            NSNumber *count = arriveDateDic[dateString];
            count = @([count intValue] + 1);
            
            arriveDateDic[dateString] = count;
        }
        
        for (NSString *date in [arriveDateDic allKeys]) {
            ActivityAcceptedDetailCellItem *item = [[ActivityAcceptedDetailCellItem alloc] init];
            item.date = date;
            item.count = [arriveDateDic[date] integerValue];
            [items addObject:item];
        }
        self.items = @[items];
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
    date.text = @"消费日期";
    [view addSubview:date];
    
    UIImageView *countImage = [[UIImageView alloc] init];
    countImage.contentMode = UIViewContentModeScaleAspectFill;
    countImage.clipsToBounds = YES;
    countImage.image = [UIImage imageNamed:@"用户"];
    [view addSubview:countImage];
    
    UILabel *count = [[UILabel alloc] init];
    count.font = SystemFontWithSize(15);
    count.textColor = DefaultTitleColor;
    count.text = @"参与人数";
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
