//
//  ImageAssetsManager.h
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/12.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AssetInfo : NSObject

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, strong) UIImage *clippedImage;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, copy)   NSString *imageDescription;
@property (nonatomic, assign) BOOL topAsset;

@end

@interface ImageAssetsManager : NSObject

@property (nonatomic, copy) NSString *activityTheme;
@property (nonatomic, copy) NSString *activityDesc;
@property (nonatomic, strong) UIImage *activityTopImage;
@property (nonatomic, strong) NSDate *activityDate;
@property (nonatomic) NSInteger activityAmount;
@property (nonatomic, strong) AVFile *audioFile;
@property (nonatomic, assign) NSTimeInterval audioDuration;

+ (instancetype)manager;

- (void)setClippedImageDescription:(NSString *)desc forKey:(ALAsset *)key;

- (void)setClippedImage:(UIImage *)image forKey:(ALAsset *)key;

- (AssetInfo *)assetInfoForKey:(ALAsset *)key;

- (NSArray *)allAssets;

- (NSArray *)allClippedImages;

- (void)removeDataForKey:(ALAsset *)key;

- (void)removeAll;

@end
