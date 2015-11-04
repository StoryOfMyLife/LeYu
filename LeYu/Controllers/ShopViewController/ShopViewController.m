//
//  ShopViewController.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/9/9.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopActivityViewController.h"
#import "TTHorizontalCategoryBar.h"
#import "TTCollectionPageViewController.h"
#import "LYLocationManager.h"
#import "TTHeartView.h"
#import <FXBlurView.h>

#import "ShopDescViewController.h"
#import "ShopMapViewController.h"

#import "YDExpandInAnimator.h"
#import "YDShrinkOutAnimator.h"

#define kTopViewHeightMax 230.0f
#define kTopViewHeightMin 64.0f

#define kHeaderViewHeight 50.0f

#define kAvatarWidthMin 40.0f
#define kAvatarWidthMax 60.0f

#define kAvatarCenterOffsetYMin 10.0f
#define kAvatarCenterOffsetYMax -40.0f

#define kContentInsetTop (kTopViewHeightMax + kHeaderViewHeight)

@interface ShopViewController () <LTableViewScrollDelegate, TTCollectionPageViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *topInfoView;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIView *shopInfoView;
@property (nonatomic, strong) TTHeartView *heartView;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) TTHorizontalCategoryBar *tabHeader;
@property (nonatomic, strong) TTCollectionPageViewController *pageViewController;

@property (nonatomic, strong) NSArray *viewControllers;

@property (nonatomic, strong) Shop *shop;

@property (nonatomic, strong) UIMotionEffectGroup *motionEffect;

@property (nonatomic, assign) CGPoint contentOffset;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactive;

@end

@implementation ShopViewController

- (instancetype)initWithShop:(Shop *)shop
{
    self = [self init];
    if (self) {
        self.shop = shop;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.topInfoView];
    [self.view addSubview:self.tabHeader];
    
    [self addChildViewController:self.pageViewController];
    [self.view insertSubview:self.pageViewController.view belowSubview:self.topInfoView];
    
    [self setupConstraints];
    
    weakSelf();
    [self.shop loadShopIcon:^(UIImage *image, NSError *error) {
        [UIView transitionWithView:weakSelf.avatar duration:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            weakSelf.avatar.image = image;
        } completion:nil];
    }];
    
    [self.shop.shopIcon getThumbnail:YES width:SCREEN_WIDTH * 2 height:kTopViewHeightMax * 2 withBlock:^(UIImage *image, NSError *error) {
        UIImage *blurredImage = [image blurredImageWithRadius:5 iterations:5 tintColor:nil];
        [UIView transitionWithView:weakSelf.backImageView duration:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            weakSelf.backImageView.image = blurredImage;
        } completion:nil];
    }];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.size = CGSizeMake(self.view.height * 1.2, self.view.height * 1.2);
    view.center = self.view.center;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = view.size.width / 2;
    self.navigationController.view.maskView = view;
    
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    edgePan.delegate = self;
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.tabHeader.selectedIndex == 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setupConstraints
{
    [self.topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@(kTopViewHeightMax));
    }];
    
    [self.tabHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topInfoView.mas_bottom);
        make.height.equalTo(@(kHeaderViewHeight));
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@80);
        make.top.equalTo(self.topInfoView);
        make.left.equalTo(self.topInfoView).offset(-20);
    }];
    
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)updateConstraintsWithOffset:(CGPoint)offset
{
//    NSLog(@"offset : %@", NSStringFromCGPoint(offset));
    CGFloat offsetY = offset.y + kContentInsetTop;
    
    CGFloat scale = 0.5;
    CGFloat newHeight = kTopViewHeightMax - offsetY * scale;
    if (newHeight >= kTopViewHeightMin) {
        
        self.contentOffset = offset;
        
        [self.topInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(newHeight));
        }];
        
        //When newHeight = kTopViewHeightMax -> ratio = 0
        //When newHeight = kTopViewHeightMin -> ratio = 1
        CGFloat ratio = (kTopViewHeightMax - newHeight) / (kTopViewHeightMax - kTopViewHeightMin);
        CGFloat delta = fabs(kAvatarCenterOffsetYMax - kAvatarCenterOffsetYMin);
        
        self.shopInfoView.alpha = 1 - ratio;
        
        [self.avatar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topInfoView).offset(kAvatarCenterOffsetYMax + delta * ratio);
        }];
        
        delta = fabs(kAvatarWidthMax - kAvatarWidthMin) / kAvatarWidthMax;
        self.avatar.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 - delta * ratio, 1 - delta * ratio);
        
        [self.likeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.topInfoView).offset(-10 + offsetY * scale / (offsetY > 0 ? 1 : 2));
        }];
        
        [self.topInfoView layoutIfNeeded];
        [self.avatar layoutIfNeeded];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)LTableViewDidScroll:(UIScrollView *)tableView
{
    [self updateConstraintsWithOffset:tableView.contentOffset];
}

#pragma mark -
#pragma mark methods

- (void)dismiss
{
    if (CGRectIsEmpty(self.presentedRect)) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)clickLikeButton:(UIButton *)sender
{
    if (!self.heartView.hasLiked) {
        [self.heartView doAnimationWithAppendAnimation:^{
        } completion:^{
            [self.shop addUniqueObject:[LYUser currentUser] forKey:@"followers"];
            [self.shop saveInBackground];
        }];
    }
}

#pragma mark -
#pragma mark Accessors

- (UIView *)shopInfoView
{
    if (!_shopInfoView) {
        _shopInfoView = [[UIView alloc] init];
        _shopInfoView.backgroundColor = [UIColor whiteColor];
        
        //店名
        UILabel *shopName = [[UILabel alloc] init];
        shopName.font = SystemBoldFontWithSize(16);
        shopName.textColor = [UIColor whiteColor];
        shopName.text = self.shop.shopname;
        
        [_shopInfoView addSubview:shopName];
        [shopName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_shopInfoView);
            make.top.equalTo(_shopInfoView);
        }];
        
        //个性描述
        UILabel *shopDesc = [[UILabel alloc] init];
        shopDesc.font = SystemFontWithSize(12);
        shopDesc.textColor = [UIColor whiteColor];
        shopDesc.text = self.shop.shopdescription;
        
        [_shopInfoView addSubview:shopDesc];
        [shopDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_shopInfoView);
            make.top.equalTo(shopName.mas_bottom).offset(10);
        }];
        
        //sub container
        UIView *locationAndPhoneContainer = [[UIView alloc] init];
        locationAndPhoneContainer.backgroundColor = [UIColor clearColor];
        [_shopInfoView addSubview:locationAndPhoneContainer];
        
        //位置
        UIImageView *locationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_white"]];
        locationView.contentMode = UIViewContentModeScaleAspectFill;
        locationView.clipsToBounds = YES;
        
        [locationAndPhoneContainer addSubview:locationView];
        [locationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(locationAndPhoneContainer);
            make.centerY.equalTo(locationAndPhoneContainer);
        }];
        
        UILabel *shopLocation = [[UILabel alloc] init];
        shopLocation.font = shopDesc.font;
        shopLocation.textColor = shopDesc.textColor;
        shopLocation.text = @"--km";
        
        AVGeoPoint *geo = self.shop.geolocation;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:geo.latitude longitude:geo.longitude];
        [[LYLocationManager sharedManager] getCurrentLocation:^(BOOL success, CLLocation *currentLocation) {
            if (success) {
                CLLocationDistance distance = [currentLocation distanceFromLocation:location];
                double distanceInKM = distance / 1000.0;
                shopLocation.text = [NSString stringWithFormat:@"%.1fkm", distanceInKM];
            }
        }];
        
        [locationAndPhoneContainer addSubview:shopLocation];
        [shopLocation mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(locationAndPhoneContainer);
            make.left.equalTo(locationView.mas_right).offset(5);
            make.centerY.equalTo(locationView);
        }];
        
        //电话
        UIImageView *phoneView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone"]];
        phoneView.contentMode = UIViewContentModeScaleAspectFill;
        phoneView.clipsToBounds = YES;
        
        [locationAndPhoneContainer addSubview:phoneView];
        [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(shopLocation.mas_right).offset(20);
            make.centerY.equalTo(shopLocation);
        }];
        
        UILabel *shopPhone = [[UILabel alloc] init];
        shopPhone.font = shopDesc.font;
        shopPhone.textColor = shopDesc.textColor;
        shopPhone.text = self.shop.telephone;
        
        [locationAndPhoneContainer addSubview:shopPhone];
        [shopPhone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(phoneView.mas_right).offset(5);
            make.centerY.equalTo(shopLocation);
        }];
        
        [locationAndPhoneContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_shopInfoView);
            make.top.equalTo(shopDesc.mas_bottom).offset(15);
            make.left.equalTo(locationView);
            make.right.equalTo(shopPhone);
        }];
        
        [_shopInfoView addMotionEffect:self.motionEffect];
    }
    return _shopInfoView;
}

- (UIImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[UIImageView alloc] init];
        _avatar.clipsToBounds = YES;
        _avatar.contentMode = UIViewContentModeScaleAspectFill;
        _avatar.image = [UIImage imageNamed:@"DefaultAvatar"];
        _avatar.layer.borderWidth = 1;
        _avatar.layer.borderColor = RGBACOLOR(238, 238, 238, 0.7).CGColor;
        _avatar.layer.cornerRadius = kAvatarWidthMax / 2;
        [_avatar addMotionEffect:self.motionEffect];
    }
    return _avatar;
}

- (UIButton *)likeButton
{
    if (!_likeButton) {
        //点赞
        _likeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _likeButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _likeButton.layer.cornerRadius = 15;
        [_likeButton addTarget:self action:@selector(clickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.heartView = [[TTHeartView alloc] init];
        [_likeButton addSubview:self.heartView];
        
        if ([LYUser currentUser]) {
            AVQuery *query = [Shop query];
            [query whereKey:@"followers" equalTo:[LYUser currentUser]];
            [query whereKey:@"objectId" equalTo:self.shop.objectId];
            NSInteger count = [query countObjects];
            if (count > 0) {
                [self.heartView doAnimationWithAppendAnimation:^{
                } completion:^{
                }];
            }
        } else {
            _likeButton.enabled = NO;
        }
        
        
        [self.heartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_likeButton);
            make.width.height.equalTo(@(20));
        }];
        
        [_likeButton addMotionEffect:self.motionEffect];
    }
    return _likeButton;
}

- (UIView *)topInfoView
{
    if (!_topInfoView) {
        _topInfoView = [[UIView alloc] init];
        _topInfoView.clipsToBounds = YES;
        _topInfoView.backgroundColor = [UIColor clearColor];
        
        self.backImageView = [[UIImageView alloc] init];
        self.backImageView.clipsToBounds = YES;
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [_topInfoView addSubview:self.backImageView];
        [_topInfoView addSubview:self.avatar];
        [_topInfoView addSubview:self.backButton];
        [_topInfoView addSubview:self.shopInfoView];
        [_topInfoView addSubview:self.likeButton];
        
        [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_topInfoView);
            make.width.height.equalTo(@(kAvatarWidthMax));
            make.centerY.equalTo(_topInfoView).offset(kAvatarCenterOffsetYMax);
        }];
        
        [self.shopInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_topInfoView);
            make.top.equalTo(self.avatar.mas_bottom).offset(10);
        }];
        
        [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_topInfoView).offset(-10);
            make.centerX.equalTo(self.shopInfoView);
            make.width.equalTo(@60);
            make.height.equalTo(@30);
        }];
        
        [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_topInfoView);
        }];
    }
    
    return _topInfoView;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _backButton.tintColor = [UIColor whiteColor];
    }
    return _backButton;
}

- (TTHorizontalCategoryBar *)tabHeader
{
    if (!_tabHeader) {
        _tabHeader = [[TTHorizontalCategoryBar alloc] init];
        _tabHeader.interitemSpacing = 70;
        _tabHeader.backgroundColor = [UIColor whiteColor];
        _tabHeader.bottomIndicatorColor = DefaultYellowColor;
        _tabHeader.categories = @[[[TTCategoryItem alloc] initWithTitle:@"店铺"],
                                  [[TTCategoryItem alloc] initWithTitle:@"活动"],
                                  [[TTCategoryItem alloc] initWithTitle:@"位置"]];
        weakSelf();
        _tabHeader.didSelectCategory = ^(NSInteger index){
            
            LTableViewController *vc0 = weakSelf.viewControllers[0];
            LTableViewController *vc1 = weakSelf.viewControllers[1];
            
            //修复：第一次加载时，cell1没有加载，使得从cell0滑向cell1时，cell1的contentOffset会重置为0，导致两个contentOffset不同步的问题。暂时解决办法是：所有view动画归0
            if (!CGPointEqualToPoint(vc1.tableView.contentOffset, vc0.tableView.contentOffset)) {
                weakSelf.contentOffset = vc1.tableView.contentOffset;
                [UIView animateWithDuration:.3 animations:^{
                    [weakSelf updateConstraintsWithOffset:CGPointMake(0, -kContentInsetTop)];//使newHeight = 0
                    [weakSelf.tabHeader layoutIfNeeded];
                }];
            }
            
            switch (index) {
                case 0:
                    vc0.delegate = weakSelf;
                    vc1.delegate = nil;
                    break;
                case 1:
                    vc0.delegate = nil;
                    vc1.delegate = weakSelf;
                    break;
                case 2:
                {
                    [UIView animateWithDuration:.3 animations:^{
                        [weakSelf updateConstraintsWithOffset:CGPointMake(0, -kContentInsetTop)];//使newHeight = 0
                        [weakSelf.tabHeader layoutIfNeeded];
                    }];
                }
                    break;
                default:
                    break;
            }
            [weakSelf.pageViewController setCurrentPage:index scrollToPage:YES];
        };
    }
    return _tabHeader;
}

- (TTCollectionPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[TTCollectionPageViewController alloc] init];
        _pageViewController.delegate = self;
        [self.view addSubview:_pageViewController.view];
        
        [_pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
        for (int i = 0; i < self.viewControllers.count; i++) {
            UIViewController *vc = self.viewControllers[i];
            [_pageViewController addChildViewController:vc];

            TTCollectionPageCellItem *item = [[TTCollectionPageCellItem alloc] init];
            item.controller = vc;
            [models addObject:item];
        }
        _pageViewController.pageItems = models;
    }
    return _pageViewController;
}

- (NSArray *)viewControllers
{
    if (!_viewControllers) {
        
        ShopActivityViewController *activityVC = [[ShopActivityViewController alloc] init];
        [activityVC view];
        activityVC.tableView.contentInset = UIEdgeInsetsMake(kContentInsetTop, 0, 0, 0);
        activityVC.tableView.scrollIndicatorInsets = activityVC.tableView.contentInset;
        activityVC.refreshEnable = NO;
        activityVC.couldShowShop = NO;
        
        AVQuery *activityQuery = [ShopActivities query];
        [activityQuery whereKey:@"isApproved" equalTo:@(1)];
        [activityQuery whereKey:@"shop" equalTo:self.shop];
        activityVC.activityQuery = activityQuery;
        
        ShopMapViewController *mapVC = [[ShopMapViewController alloc] initWithShop:self.shop];
        [mapVC view];
        mapVC.tableView.contentInset = activityVC.tableView.contentInset;
        mapVC.tableView.scrollIndicatorInsets = mapVC.tableView.contentInset;
        
        ShopDescViewController *descVC = [[ShopDescViewController alloc] initWithShop:self.shop];
        [descVC view];
        descVC.refreshEnable = NO;
        descVC.tableView.contentInset = activityVC.tableView.contentInset;
        descVC.tableView.scrollIndicatorInsets = descVC.tableView.contentInset;
        
        [RACObserve(self, contentOffset) subscribeNext:^(NSNumber *contentOffset) {
            activityVC.tableView.contentOffset = [contentOffset CGPointValue];
        }];
        
        [RACObserve(activityVC.tableView, contentOffset) subscribeNext:^(NSNumber *contentOffset) {
            descVC.tableView.contentOffset = [contentOffset CGPointValue];
        }];
        
        _viewControllers = @[descVC, activityVC, mapVC];
    }
    return _viewControllers;
}

- (UIMotionEffectGroup *)motionEffect
{
    if (!_motionEffect) {
        _motionEffect = [[UIMotionEffectGroup alloc] init];
        
        UIInterpolatingMotionEffect *motionX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionX.minimumRelativeValue = @(-20);
        motionX.maximumRelativeValue = @(20);
        
        UIInterpolatingMotionEffect *motionY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionY.minimumRelativeValue = @(-15);
        motionY.maximumRelativeValue = @(10);
        
        _motionEffect.motionEffects = @[motionX, motionY];
    }
    return _motionEffect;
}

#pragma mark -
#pragma mark Page View Controller Delegate

- (void)pageViewController:(TTCollectionPageViewController *)pageViewController pagingFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex completePercent:(CGFloat)percent
{
    [self.tabHeader updateInteractiveTransition:percent fromIndex:fromIndex toIndex:toIndex];
}

- (void)pageViewController:(TTCollectionPageViewController *)pageViewController didPagingToIndex:(NSInteger)toIndex
{
    self.tabHeader.selectedIndex = toIndex;
}

- (void)pageViewController:(TTCollectionPageViewController *)pageViewController willPagingToIndex:(NSInteger)toIndex
{
    [self.tabHeader scrollToIndex:toIndex];
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
    YDShrinkOutAnimator *animtor = [YDShrinkOutAnimator new];
    animtor.endRect = self.presentedRect;
    return animtor;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.interactive;
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    UIView *view = self.navigationController.view;
    NSLog(@"%.2f", [pan velocityInView:view].x);
    if (pan.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [pan locationInView:view];
        if (location.x < view.width) {
            self.interactive = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else if (pan.state == UIGestureRecognizerStateChanged) { // 以当前的位移作为进度执行动画
        CGPoint translation = [pan translationInView:view];
        CGFloat scale = 1.5;
        CGFloat progress = MAX(0, MIN(1, fabs(translation.x * scale / CGRectGetWidth(view.bounds))));
        [self.interactive updateInteractiveTransition:progress];
    }
    else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        CGFloat vx = [pan velocityInView:view].x;
        CGFloat tx = [pan translationInView:view].x;
        if (vx > 800 || (vx > 0 &&  tx > view.width / 2)) {
            [self.interactive finishInteractiveTransition];
        }
        else {
            [self.interactive cancelInteractiveTransition];
        }
        self.interactive = nil; // 最后必须将interactionController清空，确保不会影响到后面的动画执行
    }
}

@end
