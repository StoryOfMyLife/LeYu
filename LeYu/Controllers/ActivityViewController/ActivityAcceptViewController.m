//
//  ActivityAcceptViewController.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/30.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ActivityAcceptViewController.h"
#import "ActivityAcceptCellItem.h"
#import "ActivityUserRelation.h"

#import "YDExpandInAnimator.h"
#import "YDShrinkOutAnimator.h"
#import "YDExpandOutAnimator.h"

@interface ActivityAcceptViewController ()

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSDate *arriveDate;

@property (nonatomic, assign) BOOL cancelDismiss;

@end

@implementation ActivityAcceptViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor whiteColor];
    self.view.maskView = view;
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.width = self.view.width;
    confirmButton.height = 50;
    confirmButton.bottom = self.view.bottom;
    confirmButton.backgroundColor = DefaultYellowColor;
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = SystemFontWithSize(17);
    
    [self.view addSubview:confirmButton];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, confirmButton.height, 0);
    
    self.tableView.tableHeaderView = [self headerView];
    
    self.tableView.backgroundColor = RGBCOLOR(247, 247, 247);
    
    self.refreshEnable = NO;
    
    ActivityAcceptNameCellItem *nameItem = [[ActivityAcceptNameCellItem alloc] init];
    ActivityAcceptPhoneCellItem *phoneItem = [[ActivityAcceptPhoneCellItem alloc] init];
    ActivityAcceptDateDescCellItem *dateDescItem = [[ActivityAcceptDateDescCellItem alloc] init];
    
    ActivityAcceptDateCellItem *dateItem = [[ActivityAcceptDateCellItem alloc] init];
    
    ActivityAcceptPreferenceCellItem *preferenceItem = [[ActivityAcceptPreferenceCellItem alloc] init];
    
    [dateDescItem applyActionBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
        if ([self.items[0] count] == 3) {
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self _setItems:@[@[nameItem, phoneItem, dateDescItem, dateItem]]];
        } else {
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self _setItems:@[@[nameItem, phoneItem, dateDescItem]]];
        }
        
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kAcceptDatePickValueChanged object:nil] map:^id(NSNotification *noti) {
            UIDatePicker* datePicker = (UIDatePicker *)noti.object;
            return datePicker.date;
        }] subscribeNext:^(NSDate *date) {
            self.arriveDate = date;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy.MM.dd  hh:mm";
            NSString *dateString = [formatter stringFromDate:date];
            
            __weak ActivityAcceptDateDescCell *dateDescCell = (ActivityAcceptDateDescCell *)dateDescItem.cell;
            dateDescCell.dateLabel.text = dateString;
        }];
    }];
    
    static CGPoint originalOffset;
    
    [[[[[NSNotificationCenter  defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil] map:^id(NSNotification *noti) {
        NSDictionary* info = [noti userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        return @(kbSize.height);
    }] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *kbHeight) {
        CGFloat gap = self.view.height - self.tableView.contentSize.height - kbHeight.integerValue - 5;
        ActivityAcceptPreferenceCell *cell = (ActivityAcceptPreferenceCell *)preferenceItem.cell;
        if (gap < 0 && cell.preference.isFirstResponder) {
            originalOffset = self.tableView.contentOffset;
            [self.tableView setContentOffset:CGPointMake(0, -gap) animated:YES];
        }
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil]  takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *kbHeight) {
        [self.tableView setContentOffset:originalOffset animated:YES];
    }];
    
    self.items = @[@[nameItem, phoneItem, dateDescItem]];
}

- (UIView *)headerView
{
    UIView *view = [[UIView alloc] init];
    view.width = self.view.width;
    view.height = 200;
    
    self.avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DefaultAvatar"]];
    self.avatar.contentMode = UIViewContentModeScaleAspectFill;
    self.avatar.clipsToBounds = YES;
    self.avatar.layer.cornerRadius = 35;
    [view addSubview:self.avatar];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.width.height.mas_equalTo(70);
    }];
    
    self.name = [[UILabel alloc] init];
    self.name.text = @"乐鱼";
    self.name.font = SystemFontWithSize(16);
    self.name.textColor = RGBCOLOR_HEX(0x787878);
    [view addSubview:self.name];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(self.avatar.mas_bottom).offset(10);
    }];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.closeButton.tintColor = [UIColor blackColor];
    [self.closeButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton setImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    [view addSubview:self.closeButton];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.top.right.equalTo(view);
    }];
    
    LYUser *user = [LYUser currentUser];
    self.name.text = user.username;
    [user.thumbnail getThumbnail:YES width:100 height:100 withBlock:^(UIImage *image, NSError *error) {
        [UIView transitionWithView:self.avatar duration:.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.avatar.image = image;
        } completion:^(BOOL finished) {
        }];
    }];
    
    return view;
}

#pragma mark -
#pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    YDExpandInAnimator *animtor = [YDExpandInAnimator new];
    animtor.startRect = self.presentedRect;
    return animtor;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if (self.cancelDismiss) {
        return [YDExpandOutAnimator new];
    } else {
        YDShrinkOutAnimator *animtor = [YDShrinkOutAnimator new];
        animtor.endRect = self.presentedRect;
        return animtor;
    }
}

- (void)dismiss:(id)sender
{
    if (sender == self.closeButton) {
        self.cancelDismiss = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirm:(id)sender
{
    if ([LYUser currentUser]) {
        ActivityUserRelation *relation = [ActivityUserRelation object];
        relation.user = [LYUser currentUser];
        relation.activity = self.activity;
        relation.userArriveDate = self.arriveDate;
        [relation saveInBackground];
        
        [self.activity incrementKey:@"participantNum"];
        [self.activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

@end
