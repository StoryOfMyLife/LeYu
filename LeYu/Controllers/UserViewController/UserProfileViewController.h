//
//  UserProfileViewController.h
//  LifeO2O
//
//  Created by jiecongwang on 5/28/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LViewController.h"
typedef NS_ENUM(NSUInteger, UserProfileViewSection) {
    UserProfileInfoCellSection,
    UserLikeAndSettingCellSection,
    UserProfileViewSectionCount
};

typedef NS_ENUM(NSUInteger, LikeAndSettingSection) {
    Like,
    Setting,
    count,
};


@interface UserProfileViewController : LViewController

@property (nonatomic,strong) UITableView *tableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)registerTableCells;

-(UIView *)tableHeaderView;

-(void)setUpTitle;

@end
