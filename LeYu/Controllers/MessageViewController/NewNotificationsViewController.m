//
//  NewNotificationsViewController.m
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/22.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "NewNotificationsViewController.h"
#import "NotificationMessageCell.h"
#import "NotificationMessage.h"
#import "ColorFactory.h"

@interface NewNotificationsViewController ()

@property(nonatomic,strong) NSMutableArray *notifications;

@end

@implementation NewNotificationsViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.notifications = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"消息";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.notifications count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(NotificationMessageCell.class) forIndexPath:indexPath];
    NotificationMessage *message = [self.notifications objectAtIndex:indexPath.row];
    NSString *shopName = @"";
    if (message.shop) {
        shopName =  message.shop.shopname;
    }
    [cell configureNotificationMessage:message.newActivites withShopName:shopName];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)registerTableCells
{
   [self.tableView registerClass:NotificationMessageCell.class forCellReuseIdentifier:NSStringFromClass(NotificationMessageCell.class)];
}

- (UIView *)tableHeaderView
{
    UIView *newWrapperView = [[UIView alloc] initWithFrame:CGRectMake(0,0 ,self.view.bounds.size.width, 70.0f)];
    newWrapperView.backgroundColor = [ColorFactory dyLightGray];
    UIView *buttonView = [[UIView alloc] init];
    [[buttonView layer] setBorderWidth:2.0f];
    [[buttonView layer] setBorderColor:UIColorFromRGB(0xC4A24A).CGColor];
    [newWrapperView addSubview:buttonView];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"Remind"];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [buttonView addSubview:imageView];
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textAlignment =  NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"System" size:14.0f];
    label.textColor = UIColorFromRGB(0xC4A24A);
    label.text = @"活动通知";
    [buttonView addSubview:label];
    UIImageView *arrow = [[UIImageView alloc] init];
    arrow.image = [UIImage imageNamed:@"next"];
    arrow.clipsToBounds = YES;
    arrow.contentMode =  UIViewContentModeScaleAspectFit;
    [buttonView addSubview:arrow];
    
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newWrapperView.mas_top).with.offset(10.0f);
        make.bottom.equalTo(newWrapperView.mas_bottom).with.offset(-10.0f);
        make.left.equalTo(newWrapperView.mas_left).with.offset(5.0f);
        make.right.equalTo(newWrapperView.mas_right).with.offset(-5.0f);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(buttonView.mas_centerY);
        make.height.equalTo(@(40.0f));
        make.centerX.equalTo(buttonView.mas_centerX);
        make.width.equalTo(buttonView.mas_width).dividedBy(3);
        
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.height.equalTo(label.mas_height);
        make.width.equalTo(@(30));
        make.right.equalTo(label.mas_left).with.offset(5.0f);
    }];
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label.mas_centerY);
        make.height.equalTo(@(15.0f));
        make.width.equalTo(@(15.0f));
        make.right.equalTo(buttonView.mas_right).with.offset(-10.0f);
        
    }];
    return newWrapperView;
}

@end
