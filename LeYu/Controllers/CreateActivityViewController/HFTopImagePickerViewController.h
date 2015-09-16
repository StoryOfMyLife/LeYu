//
//  HFTopImagePickerViewController.h
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/14.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "CTAssetsPickerController.h"

@interface HFTopImagePickerViewController : UICollectionViewController

@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) ALAsset *selectedAsset;

@end
