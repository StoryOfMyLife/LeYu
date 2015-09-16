//
//  ImagePreviewViewController.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/8/3.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ImagePreviewViewController.h"

#import "YDPresentFadeInAnimator.h"
#import "YDDismissFadeOutAnimator.h"

@interface ImagePreviewViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *indexLabel;

@end

@implementation ImagePreviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.frame = self.view.bounds;
    [self.view addSubview:blurView];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismiss)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    [self.view addSubview:self.scrollView];
    
    [self.view addSubview:self.indexLabel];
    
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-35);
    }];
}

#pragma mark -
#pragma mark getters and setter

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.width = self.view.width;
        _scrollView.height = _scrollView.width * 540.0f / 600.0f;
        _scrollView.center = self.view.center;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(_scrollView.width * self.images.count, _scrollView.height);
        
        for (NSInteger i = 0; i < self.images.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.left = _scrollView.width * i;
            imageView.image = self.images[i];
            [_scrollView addSubview:imageView];
        }
        [_scrollView setContentOffset:CGPointMake(_scrollView.width * self.currentIndex, 0)];
    }
    return _scrollView;
}

- (UILabel *)indexLabel
{
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = SystemFontWithSize(17);
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.text = [NSString stringWithFormat:@"%ld / %lu", (long)(self.currentIndex + 1), (unsigned long)self.images.count];
    }
    return _indexLabel;
}

#pragma mark -
#pragma mark scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / scrollView.width + 1;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld / %lu", (long)pageIndex,
                            (unsigned long)self.images.count];
}

#pragma mark -
#pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [YDPresentFadeInAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [YDDismissFadeOutAnimator new];
}

#pragma mark -
#pragma mark gesture

- (void)tapToDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
