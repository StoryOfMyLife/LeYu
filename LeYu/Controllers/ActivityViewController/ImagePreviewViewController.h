//
//  ImagePreviewViewController.h
//  LifeO2O
//
//  Created by 刘廷勇 on 15/8/3.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "LViewController.h"

@interface ImagePreviewViewController : LViewController <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) NSInteger currentIndex;

@end
