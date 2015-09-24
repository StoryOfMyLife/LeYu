//
//  HFActivityEditViewController.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/15.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "HFActivityEditViewController.h"
#import "ActivityCreatorItems.h"
#import "ImageAssetsManager.h"
#import "ShopActivities.h"

@interface HFActivityEditViewController ()

@end

@implementation HFActivityEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupButtons];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.refreshEnable = NO;
    
    ActivityThemeCellItem *themeItem = [[ActivityThemeCellItem alloc] init];
    ActivityPhotoCellItem *photoItem = [[ActivityPhotoCellItem alloc] init];
    ActivityShopNameCellItem *shopNameItem = [[ActivityShopNameCellItem alloc] init];
    
    shopNameItem.shopName = [LYUser currentUser].shop.shopname;
    
    ActivityDescriptionCellItem *descItem = [[ActivityDescriptionCellItem alloc] init];
    ActivityTimeCellItem *timeItem = [[ActivityTimeCellItem alloc] init];
    ActivityTimeSelectionCellItem *timeSelectionItem = [[ActivityTimeSelectionCellItem alloc] init];
    ActivityAmountCellItem *amountItem = [[ActivityAmountCellItem alloc] init];
    ActivityAmountSelectionCellItem *amountSelectionItem = [[ActivityAmountSelectionCellItem alloc] init];
    
    [ImageAssetsManager manager].activityDate = [NSDate dateWithTimeInterval:aWeek sinceDate:[NSDate date]];
    
    [descItem applyActionBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
        __weak ActivityDescriptionCell *descCell = (ActivityDescriptionCell *)descItem.cell;
        [descCell.descriptionView becomeFirstResponder];
    }];
    
    [timeItem applyActionBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
        if ([self.items[0] count] == 6) {
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self _setItems:@[@[themeItem, photoItem, shopNameItem, descItem, timeItem, timeSelectionItem, amountItem]]];
        } else {
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self _setItems:@[@[themeItem, photoItem, shopNameItem, descItem, timeItem, amountItem]]];
        }
        
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kDatePickValueChanged object:nil] map:^id(NSNotification *noti) {
            UIDatePicker* datePicker = (UIDatePicker *)noti.object;
            return datePicker.date;
        }] subscribeNext:^(NSDate *date) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy.MM.dd";
            NSString *startDate = [formatter stringFromDate:date];
            NSString *endDate = [formatter stringFromDate:[date dateByAddingTimeInterval:aWeek]];
            
            __weak ActivityTimeCell *timeCell = (ActivityTimeCell *)timeItem.cell;
            timeCell.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", startDate, endDate];
            
            [ImageAssetsManager manager].activityDate = date;
        }];
    }];
    
    [amountItem applyActionBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
        if ([self.items[indexPath.section] containsObject:amountSelectionItem]) {
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
            NSMutableArray *newItems = [NSMutableArray arrayWithArray:self.items[indexPath.section]];
            [newItems removeObject:amountSelectionItem];
            
            [self _setItems:@[newItems]];
        } else {
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

            NSMutableArray *newItems = [NSMutableArray arrayWithArray:self.items[indexPath.section]];
            [newItems addObject:amountSelectionItem];

            [self _setItems:@[newItems]];
        }
        
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kAmountPickValueChanged object:nil] map:^id(NSNotification *noti) {
            NSString *amount = (NSString *)noti.object;
            return amount;
        }] subscribeNext:^(NSString *amount) {
            __weak ActivityAmountCell *amountCell = (ActivityAmountCell *)amountItem.cell;
            amountCell.amountLabel.text = amount;
            [ImageAssetsManager manager].activityAmount = [amount integerValue];
        }];
    }];
    
    
    self.items = @[@[themeItem, photoItem, shopNameItem, descItem, timeItem, amountItem]];
}

- (void)setupButtons
{
    if (!self.navigationItem.rightBarButtonItem) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.titleLabel.font = SystemBoldFontWithSize(16);
        rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [rightButton setTitle:@"发布" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        [rightButton sizeToFit];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
}

- (void)send
{
    [self.view endEditing:YES];
    
    ImageAssetsManager *manager = [ImageAssetsManager manager];
    ShopActivities *activity = [ShopActivities object];
    activity.title = manager.activityTheme;
    activity.activitiesDescription = manager.activityDesc;
    activity.totalNum = @(manager.activityAmount);
    activity.beginDate = [NSDate date];
    activity.endDate = manager.activityDate;

    activity.shop = [LYUser currentUser].shop;
    
    NSArray *imageAssets = [manager allAssets];
    NSMutableArray *imageIds = [NSMutableArray arrayWithCapacity:0];
    for (ALAsset *asset in imageAssets) {
        AssetInfo *imageInfo = [manager assetInfoForKey:asset];
        NSData *imageData = UIImagePNGRepresentation(imageInfo.clippedImage);
        
        NSString *name = @"让我们更美的去生活。";
        if ([imageInfo.imageDescription length] > 0) {
            name = imageInfo.imageDescription;
        }
        NSString *imageName = [NSString stringWithFormat:@"%@.png", name];
        AVFile *imageFile = [AVFile fileWithName:imageName data:imageData];
        [imageFile save];
        
        if (imageInfo.topAsset) {
            [imageIds insertObject:imageFile.objectId atIndex:0];
        } else {
            [imageIds addObject:imageFile.objectId];
        }
    }
    [activity addObjectsFromArray:imageIds forKey:@"pics"];
    
    NSError *error = nil;
    [activity save:&error];
    if (!error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        Log(@"%@", error);
    }
}

@end
