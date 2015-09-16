//
//  HFCreateAvtivityViewController.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/11.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "HFCreateAvtivityViewController.h"
#import "HFImageEditingViewController.h"
#import "ImageAssetsManager.h"

@interface HFCreateAvtivityViewController () <CTAssetsPickerControllerDelegate>

@end

@implementation HFCreateAvtivityViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.assetsFilter = [ALAssetsFilter allPhotos];
        self.showsCancelButton = YES;
        self.showsNumberOfAssets = NO;
    }
    return self;
}

#pragma mark -
#pragma mark - Assets Picker Delegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    HFImageEditingViewController *imageEditingVC = [[HFImageEditingViewController alloc] initWithNibName:nil bundle:nil];
    imageEditingVC.hidesBottomBarWhenPushed = YES;
    imageEditingVC.assets = assets;
    [picker.childNavigationController pushViewController:imageEditingVC animated:YES];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    if (picker.selectedAssets.count >= 8) {
        return NO;
    }
    return YES;
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didDeselectAsset:(ALAsset *)asset
{
    [[ImageAssetsManager manager] removeDataForKey:asset];
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker
{
    [[ImageAssetsManager manager] removeAll];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    if ([[group valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue] == ALAssetsGroupSavedPhotos) {
        return YES;
    } else {
        return NO;
    }
}

@end
