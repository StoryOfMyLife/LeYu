//
//  HFTopImagePickerViewController.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/14.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "HFTopImagePickerViewController.h"
#import "CTAssetsViewCell.h"
#import "CTAssetsSupplementaryView.h"
#import "ImageAssetsManager.h"
#import "UIBarButtonItem+Badge.h"
#import "NSBundle+CTAssetsPickerController.h"
#import "CTAssetsPickerCommon.h"
#import "HFActivityEditViewController.h"

NSString * const AssetsViewCellIdentifier = @"AssetsViewCellIdentifier";

@interface HFTopImagePickerViewController ()

@end

@implementation HFTopImagePickerViewController

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [self collectionViewFlowLayout];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.clearsSelectionOnViewWillAppear = NO;
        [self.collectionView registerClass:CTAssetsViewCell.class
                forCellWithReuseIdentifier:AssetsViewCellIdentifier];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupViews];
    [self setupButtons];
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self localize];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)localize
{
    self.title = CTAssetsPickerControllerLocalizedString(@"活动头图选择");
}

#pragma mark - Reload Data

- (void)reloadData
{
    if (self.assets.count > 0) {
        [self.collectionView reloadData];
        
        if (self.collectionView.contentOffset.y <= 0)
            [self.collectionView setContentOffset:CGPointMake(0, self.collectionViewLayout.collectionViewContentSize.height)];
    }
}

#pragma mark - Setup

- (void)setupViews
{
    self.collectionView.backgroundColor = DefaultBackgroundColor;
}

- (void)setupButtons
{
    if (!self.navigationItem.rightBarButtonItem) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.titleLabel.font = SystemBoldFontWithSize(16);
        rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [rightButton setTitle:CTAssetsPickerControllerLocalizedString(@"Next") forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [rightButton sizeToFit];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        
        self.navigationItem.rightBarButtonItem.badgeValue = @"0";
        self.navigationItem.rightBarButtonItem.badgeBGColor = RGBCOLOR(197, 136, 10);
        self.navigationItem.rightBarButtonItem.badgeOriginX = -23;
        self.navigationItem.rightBarButtonItem.badgeOriginY = 5;
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - Collection View Layout

- (UICollectionViewFlowLayout *)collectionViewFlowLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat space = 3.0;
    
    NSInteger width = (SCREEN_WIDTH - 4 * space) / 3;
    layout.itemSize             = CGSizeMake(width, width);
    
    layout.sectionInset            = UIEdgeInsetsMake(space, space, space, space);
    layout.minimumInteritemSpacing = space;
    layout.minimumLineSpacing      = space;
    
    return layout;
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTAssetsViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:AssetsViewCellIdentifier
                                              forIndexPath:indexPath];
    
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    cell.enabled = YES;
    
    // XXX
    // Setting `selected` property blocks further deselection.
    // Have to call selectItemAtIndexPath too. ( ref: http://stackoverflow.com/a/17812116/1648333 )
    if (self.selectedAsset == asset)
    {
        cell.selected = YES;
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    [cell bind:asset];
    
    return cell;
}

#pragma mark - Collection View Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CTAssetsViewCell *cell = (CTAssetsViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (!cell.isEnabled)
        return NO;
    else
        return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.badgeValue = @"1";
    self.selectedAsset = asset;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)next
{
    AssetInfo *info = [[ImageAssetsManager manager] assetInfoForKey:self.selectedAsset];
    info.topAsset = YES;
    [ImageAssetsManager manager].activityTopImage = info.clippedImage;
    
    HFActivityEditViewController *vc = [[HFActivityEditViewController alloc] init];
    vc.title = @"活动";
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
