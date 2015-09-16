//
//  HFImageEditingViewController.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/11.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "HFImageEditingViewController.h"
#import "NSBundle+CTAssetsPickerController.h"
#import "HFTopImagePickerViewController.h"

#import "UIButton+Center.h"
#import "GCPlaceholderTextView.h"

#import "ImageAssetsManager.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

static const NSInteger kTagOffset = 1000;

@interface HFImageEditingViewController () <UIScrollViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIView *topPreviewView;
@property (nonatomic, strong) UIView *middleImageView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIImageView *editingImageView;
@property (nonatomic, strong) CAGradientLayer *rightGradient;
@property (nonatomic, strong) CAGradientLayer *leftGradient;

@property (nonatomic, assign) CGSize editingContentSize;

@property (nonatomic, strong) UIButton *clipButton;
@property (nonatomic, strong) UIButton *textButton;

@property (nonatomic, strong) UIView *descriptionView;
@property (nonatomic, strong) GCPlaceholderTextView *descTextView;

@property (nonatomic, assign) NSInteger currentSelectedIndex;

@property (nonatomic, strong) NSMutableDictionary *clippedImageDict;

@end

@implementation HFImageEditingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    self.navigationItem.titleView = self.topPreviewView;
    self.title = @"";
    
    [self setupButtons];
    [self.view addSubview:self.middleImageView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.descriptionView];
    
    self.currentSelectedIndex = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    [self.view layoutIfNeeded];
    
    [[[[[NSNotificationCenter  defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil] map:^id(NSNotification *noti) {
        NSDictionary* info = [noti userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        return @(kbSize.height);
    }] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *kbHeight) {
        CGFloat gap = self.view.height - self.middleImageView.bottom - kbHeight.integerValue;
        if (gap < 0) {
            [self.descriptionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.middleImageView).offset(gap);
            }];
            [UIView animateWithDuration:0.5 animations:^{
                [self.descriptionView layoutIfNeeded];
            }];
        }
    }];
    
    [[[[NSNotificationCenter  defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil]  takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *kbHeight) {
        [self.descriptionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.middleImageView);
        }];
        [UIView animateWithDuration:0.1 animations:^{
            [self.descriptionView layoutIfNeeded];
        }];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)updateViewConstraints
{
    [self.descriptionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.middleImageView);
        make.height.equalTo(@90);
    }];
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.bottom.equalTo(self.view);
        make.top.equalTo(self.middleImageView.mas_bottom);
    }];
    
    [self.clipButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView).multipliedBy(0.66);
        make.centerY.equalTo(self.bottomView);
    }];
    
    [self.textButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView).multipliedBy(1.33);
        make.centerY.equalTo(self.bottomView);
    }];
    
    [super updateViewConstraints];
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
        self.navigationItem.rightBarButtonItem.enabled = [self enableNextButton];
    }
}

#pragma mark - ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.width)) {
        self.rightGradient.hidden = YES;
    } else {
        self.rightGradient.hidden = NO;
    }
    
    if (scrollView.contentOffset.x > 0) {
        self.leftGradient.hidden = NO;
    } else {
        self.leftGradient.hidden = YES;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.editingImageView;
}

#pragma mark - TextView delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(range.length + range.location > textView.text.length) {
        return NO;
    }
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return newLength <= 60 || [text isEqualToString:@""];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    ALAsset *asset = self.assets[_currentSelectedIndex];
    [[ImageAssetsManager manager] setClippedImageDescription:textView.text forKey:asset];
}

#pragma mark - setter and getter

- (void)setCurrentSelectedIndex:(NSInteger)currentSelectedIndex
{
    _currentSelectedIndex = currentSelectedIndex;
    
    ALAsset *asset = self.assets[currentSelectedIndex];
    AssetInfo *info = [[ImageAssetsManager manager] assetInfoForKey:asset];
    UIImage *image = info.clippedImage;
    if (!image) {
        image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
    }
    
    self.descTextView.text = info.imageDescription;
    
    [UIView transitionWithView:self.editingImageView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
        self.editingImageView.image = image;
    } completion:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        for (NSInteger i = 0; i < self.assets.count; i++) {
            UIView *view = [self.topPreviewView viewWithTag:(i + kTagOffset)];
            if (i != currentSelectedIndex) {
                view.alpha = 0.3;
            } else {
                view.alpha = 1;
            }
        }
    }];
}

- (UIView *)topPreviewView
{
    if (!_topPreviewView) {
        CGFloat height = self.navigationController.navigationBar.height;
        CGFloat gap = 10;
        NSInteger count = self.assets.count + 1;
        
        _topPreviewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 150, height)];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:_topPreviewView.bounds];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentSize = CGSizeMake(count * height + (count - 1) * gap, height);
//        scrollView.width = MIN(_topPreviewView.width, scrollView.contentSize.width);
//        scrollView.centerX = _topPreviewView.centerX;
        [_topPreviewView addSubview:scrollView];
        
        for (NSInteger i = 0; i < count; i++) {
            UIImageView *previewView = [[UIImageView alloc] init];
            previewView.userInteractionEnabled = YES;
            previewView.tag = kTagOffset + i;
            if (i < self.assets.count) {
                ALAsset *asset = self.assets[i];
                previewView.layer.borderWidth = 1;
                previewView.layer.borderColor = DefaultYellowColor.CGColor;
                previewView.image = [UIImage imageWithCGImage:asset.thumbnail];
                
                if (i == 0) {
                    previewView.alpha = 1;
                } else {
                    previewView.alpha = 0.3;
                }
            } else {
                previewView.image = [UIImage imageNamed:@"AddMore"];
            }
            previewView.size = CGSizeMake(height, height);
            previewView.left = i * (height + gap);
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectImage:)];
            [previewView addGestureRecognizer:tap];
            
            [scrollView addSubview:previewView];
        }
        
        if (scrollView.contentSize.width > scrollView.width) {
            self.rightGradient = [CAGradientLayer layer];
            CGFloat gradientWidth = height / 2;
            self.rightGradient.frame = CGRectMake(_topPreviewView.width - gradientWidth, 0, gradientWidth, _topPreviewView.height);
            self.rightGradient.colors = @[(id)[UIColor clearColor].CGColor, (id)DefaultBackgroundColor.CGColor];
            self.rightGradient.startPoint = CGPointMake(0, 0.5);
            self.rightGradient.endPoint = CGPointMake(1, 0.5);
            
            self.leftGradient = [CAGradientLayer layer];
            self.leftGradient.frame = CGRectMake(0, 0, gradientWidth, _topPreviewView.height);
            self.leftGradient.colors = @[(id)DefaultBackgroundColor.CGColor, (id)[UIColor clearColor].CGColor];
            self.leftGradient.startPoint = CGPointMake(0, 0.5);
            self.leftGradient.endPoint = CGPointMake(1, 0.5);
            
            [_topPreviewView.layer addSublayer:self.leftGradient];
            [_topPreviewView.layer addSublayer:self.rightGradient];
        }
    }
    return _topPreviewView;
}

- (UIView *)middleImageView
{
    if (!_middleImageView) {
        _middleImageView = [[UIView alloc] init];
        _middleImageView.width = self.view.width;
        _middleImageView.height = self.view.width * 10.0 / 9.0;
        _middleImageView.top = self.view.top + 20;
        
        _middleImageView.layer.borderWidth = 2;
        _middleImageView.layer.borderColor = DefaultYellowColor.CGColor;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:_middleImageView.bounds];
        
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.maximumZoomScale = 5;
        scrollView.minimumZoomScale = 1;
        scrollView.zoomScale = 1;
        
        [scrollView addSubview:self.editingImageView];
        [_middleImageView addSubview:scrollView];
        
        weakSelf();
        [RACObserve(self.editingImageView, image) subscribeNext:^(UIImage *image) {
            if (image) {
                CGSize imageSize = image.size;
                CGFloat scale = 1.0;
                if (imageSize.width < imageSize.height) {
                    scale = scrollView.width / imageSize.width;
                } else {
                    scale = scrollView.height / imageSize.height;
                }
                weakSelf.editingContentSize = CGSizeMake(imageSize.width * scale, imageSize.height * scale);
            }
        }];
        
        [RACObserve(self, editingContentSize) subscribeNext:^(NSNumber *size) {
            CGSize contentSize = [size CGSizeValue];
            if (contentSize.width > 0) {
                scrollView.contentSize = contentSize;
                weakSelf.editingImageView.transform = CGAffineTransformIdentity;
                weakSelf.editingImageView.frame = (CGRect){CGPointZero, contentSize};
                
                CGPoint centerOffset = CGPointMake((contentSize.width - scrollView.width) / 2,
                                                   (contentSize.height - scrollView.height) / 2);
                [scrollView setContentOffset:centerOffset animated:NO];
                [weakSelf.view setNeedsUpdateConstraints];
            }
        }];
        
    }
    return _middleImageView;
}

- (UIImageView *)editingImageView
{
    if (!_editingImageView) {
        _editingImageView = [[UIImageView alloc] initWithFrame:self.middleImageView.bounds];
        _editingImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _editingImageView;
}

- (UIView *)descriptionView
{
    if (!_descriptionView) {
        _descriptionView = [[UIView alloc] init];
        _descriptionView.backgroundColor = RGBACOLOR_HEX(0x262420, 0.7);
        _descriptionView.alpha = 0;
        
        [_descriptionView addSubview:self.descTextView];
        
        [self.descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_descriptionView);
        }];
    }
    return _descriptionView;
}

- (GCPlaceholderTextView *)descTextView
{
    if (!_descTextView) {
        _descTextView = [[GCPlaceholderTextView alloc] init];
        _descTextView.delegate = self;
        _descTextView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _descTextView.backgroundColor = [UIColor clearColor];
        _descTextView.tintColor = DefaultYellowColor;
        _descTextView.textColor = [UIColor whiteColor];
        _descTextView.font = SystemFontWithSize(14);
        _descTextView.placeholder = @"说点什么吧!";
        _descTextView.placeholderColor = [UIColor lightGrayColor];
        
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.textAlignment = NSTextAlignmentRight;
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.font = SystemFontWithSize(10);
        [_descriptionView addSubview:numberLabel];
        
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.bottom.equalTo(_descriptionView).offset(-5);
        }];
        
        [[_descTextView.rac_textSignal map:^id(NSString *text) {
            return @(text.length)
            ;
        }] subscribeNext:^(NSNumber *length) {
            numberLabel.text = [NSString stringWithFormat:@"%ld/60", (long)length.integerValue];
        }];
        
        [[RACObserve(_descTextView, text) map:^id(NSString *text) {
            return @(text.length);
        }] subscribeNext:^(NSNumber *length) {
            numberLabel.text = [NSString stringWithFormat:@"%ld/60", (long)length.integerValue];
        }];
    }
    return _descTextView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}

- (UIButton *)clipButton
{
    if (!_clipButton) {
        _clipButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_clipButton addTarget:self action:@selector(clipImage) forControlEvents:UIControlEventTouchUpInside];
        [_clipButton setTintColor:DefaultYellowColor];
        [_clipButton setImage:[UIImage imageNamed:@"clipButton"] forState:UIControlStateNormal];
        [_clipButton setTitle:@"裁剪" forState:UIControlStateNormal];
        [_clipButton centerImage];
        
        [self.bottomView addSubview:_clipButton];
    }
    return _clipButton;
}

- (UIButton *)textButton
{
    if (!_textButton) {
        _textButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_textButton addTarget:self action:@selector(addDescription) forControlEvents:UIControlEventTouchUpInside];
        [_textButton setTintColor:RGBCOLOR_HEX(0xaaaaaa)];
        [_textButton setImage:[UIImage imageNamed:@"textButton"] forState:UIControlStateNormal];
        [_textButton setTitle:@"描述" forState:UIControlStateNormal];
        [_textButton centerImage];
        
        [self.bottomView addSubview:_textButton];
    }
    return _textButton;
}

#pragma mark - methods

- (void)didSelectImage:(UITapGestureRecognizer *)sender
{
    NSInteger index = sender.view.tag - kTagOffset;
    if (index < self.assets.count) {
        self.currentSelectedIndex = index;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIImage *)currentClippedImage
{
    CGFloat borderWidth = self.middleImageView.layer.borderWidth;
    self.middleImageView.layer.borderWidth = 0;
    UIGraphicsBeginImageContextWithOptions(self.middleImageView.size, YES, 1);
    [self.middleImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *clippedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.middleImageView.layer.borderWidth = borderWidth;
    
    //show clip indicator
    UIView *clipIndicatorView = [[UIView alloc] init];
    clipIndicatorView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.navigationController.view addSubview:clipIndicatorView];
    [clipIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        clipIndicatorView.alpha = 0;
    } completion:^(BOOL finished) {
        [clipIndicatorView removeFromSuperview];
    }];
    
    return clippedImage;
}

- (void)clipImage
{
    if (!self.middleImageView.userInteractionEnabled) {
        self.middleImageView.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.clipButton.tintColor = DefaultYellowColor;
            self.textButton.tintColor = RGBCOLOR_HEX(0xaaaaaa);
            self.descriptionView.alpha = 0;
        }];
    } else {
        ALAsset *asset = self.assets[_currentSelectedIndex];
        [[ImageAssetsManager manager] setClippedImage:[self currentClippedImage] forKey:asset];
        
        self.navigationItem.rightBarButtonItem.enabled = [self enableNextButton];
    }
}

- (void)addDescription
{
    self.middleImageView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.textButton.tintColor = DefaultYellowColor;
        self.clipButton.tintColor = RGBCOLOR_HEX(0xaaaaaa);
        self.descriptionView.alpha = 1;
    }];
}

- (BOOL)enableNextButton
{
    return [[[ImageAssetsManager manager] allAssets] count] == [self.assets count];
}

- (void)tapToDismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)next
{
    HFTopImagePickerViewController *topImagePickerVC = [[HFTopImagePickerViewController alloc] init];
    topImagePickerVC.assets = self.assets;
    [self.navigationController pushViewController:topImagePickerVC animated:YES];
}

@end
