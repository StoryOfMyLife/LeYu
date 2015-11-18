//
//  ImageAssetsManager.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/12.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ImageAssetsManager.h"

@implementation AssetInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.topAsset = NO;
    }
    return self;
}

- (UIImage *)originalImage
{
    return [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullResolutionImage]];
}

@end

@interface ImageAssetsManager ()

@property (nonatomic, strong) NSMutableDictionary *assetInfo;

@end

@implementation ImageAssetsManager

+ (instancetype)manager
{
    static ImageAssetsManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ImageAssetsManager alloc] init];
    });
    return _sharedInstance;
}

- (NSMutableDictionary *)assetInfo
{
    if (!_assetInfo) {
        _assetInfo = [NSMutableDictionary dictionary];
    }
    return _assetInfo;
}

- (void)setClippedImageDescription:(NSString *)desc forKey:(ALAsset *)key withOrderIndex:(NSInteger)order
{
    AssetInfo *info = self.assetInfo[[self urlForAsset:key]];
    if (!info) {
        info = [[AssetInfo alloc] init];
        info.asset = key;
    }
    info.imageDescription = desc;
    info.order = order;
    self.assetInfo[[self urlForAsset:key]] = info;
}

- (void)setClippedImage:(UIImage *)image forKey:(ALAsset *)key withOrderIndex:(NSInteger)order
{
    AssetInfo *info = self.assetInfo[[self urlForAsset:key]];
    if (!info) {
        info = [[AssetInfo alloc] init];
        info.asset = key;
    }
    info.clippedImage = image;
    info.order = order;
    self.assetInfo[[self urlForAsset:key]] = info;
}

- (AssetInfo *)assetInfoForKey:(ALAsset *)key
{
    return self.assetInfo[[self urlForAsset:key]];
}

- (NSArray *)allAssets
{
    NSArray *allAssetsInfo = [self.assetInfo allValues];
    allAssetsInfo = [allAssetsInfo sortedArrayUsingComparator:^NSComparisonResult(AssetInfo *obj1, AssetInfo *obj2) {
        if (obj1.order < obj2.order) {
            return NSOrderedAscending;
        }
        if (obj1.order > obj2.order) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    NSMutableArray *assets = [NSMutableArray array];
    for (AssetInfo *info in allAssetsInfo) {
        [assets addObject:info.asset];
    }
    return assets;
}

- (NSArray *)allClippedImages
{
    NSArray *allAssetsInfo = [self.assetInfo allValues];
    NSArray *sortedAssetsInfo = [allAssetsInfo sortedArrayUsingComparator:^NSComparisonResult(AssetInfo *obj1, AssetInfo *obj2) {
        if (obj1.order < obj2.order) {
            return NSOrderedAscending;
        }
        if (obj1.order > obj2.order) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    NSMutableArray *clippedImages = [NSMutableArray array];
    for (AssetInfo *info in sortedAssetsInfo) {
        if (info.clippedImage) {
            [clippedImages addObject:info.clippedImage];
        }
    }
    return clippedImages;
}

- (void)removeDataForKey:(ALAsset *)key
{
    [self.assetInfo removeObjectForKey:[self urlForAsset:key]];
}

- (void)removeAll
{
    [self.assetInfo removeAllObjects];
}

- (NSString *)urlForAsset:(ALAsset *)asset
{
    return [asset valueForProperty:ALAssetPropertyAssetURL];
}

@end
