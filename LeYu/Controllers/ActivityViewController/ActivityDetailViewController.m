//
//  ActivitiesViewController.m
//  LifeO2O
//
//  Created by jiecongwang on 5/28/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ShopActivities.h"
#import "OtherActivityCell.h"
#import "ActivityDetailCellItem.h"
#import "ShopViewController.h"
#import "ActivityAcceptViewController.h"
#import "ImagePreviewViewController.h"
#import "LYLocationManager.h"

@interface ActivityDetailViewController ()

@property (nonatomic, strong) ShopActivities *activities;
@property (nonatomic, strong) NSArray *imageFileIds; // of AVFile id
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *imagesDesc;
@property (nonatomic, strong) UIImageView *cardImage;
@property (nonatomic, strong) UILabel *imageDescLabel;
@property (nonatomic, strong) UILabel *imageIndexLabel;

@property (nonatomic, strong) ActivityDetailCellItem *activityDetailItem;

@property (nonatomic, strong) NSArray *otherActivities;

@property (nonatomic) NSInteger imageIndex;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *acceptButton;

@property (nonatomic, strong) UIImageView *shopIcon;

@end

@implementation ActivityDetailViewController

- (instancetype)initWithActivities:(ShopActivities *)activities {
    if (self = [self init]) {
        self.activities = activities;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self setTitleView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *tableHeaderView = [self tableHeaderView];
    tableHeaderView.height = [tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.tableView.tableHeaderView = tableHeaderView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = RGBCOLOR_HEX(0xf7f7f7);
    
    self.imageIndex = 0;
    
    self.activityDetailItem = [[ActivityDetailCellItem alloc] init];
    self.activityDetailItem.activity = self.activities;
    
    weakSelf();
    self.items = @[@[self.activityDetailItem]];
    
    [self convertFilesToImages:self.imageFileIds];
    self.updateBlock = ^{
        [weakSelf loadData];
    };
    
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.bottomView addSubview:self.acceptButton];
    
    [self.acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomView);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setTitleView
{
    AVFile *iconFile = self.activities.shop.shopIcon;
    [iconFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:[iconFile getData]];
        UIImageView *titleImage = [[UIImageView alloc] initWithImage:image];
        titleImage.clipsToBounds = YES;
        titleImage.contentMode = UIViewContentModeScaleAspectFit;
        titleImage.width = 30;
        titleImage.height = 30;
        self.navigationItem.titleView = titleImage;
    }];
}

#pragma mark -
#pragma mark methods

- (void)loadData
{
    AVQuery *query = [ShopActivities query];
    [query whereKey:@"shop" equalTo:self.activities.shop];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities,NSError *error) {
        if (!error) {
            NSMutableArray *result = [NSMutableArray arrayWithArray:activities];
            [result removeObject:self.activities];
            
            //过滤掉已经接受的活动
            NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:0];
            [result enumerateObjectsUsingBlock:^(ShopActivities *obj, NSUInteger idx, BOOL *stop) {
                if (!obj.accepted) {
                    [tmp addObject:obj];
                }
            }];
            self.otherActivities = tmp;
            
            for (ShopActivities *activity in self.otherActivities) {
                activity.shop = self.activities.shop;
                activity.otherActivity = YES;
                
                [activity applyActionBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
                    ShopActivities *activities = self.otherActivities[indexPath.row];
                    ActivityDetailViewController *activitiesViewController = [[ActivityDetailViewController alloc] initWithActivities:activities];
                    [self.navigationController pushViewController:activitiesViewController animated:YES];
                }];
                
                activity.handleBlock = ^(NSDictionary *info){
                    UIView *sender = info[@"sender"];
                    CGRect rect = [self.view convertRect:sender.frame fromView:sender.superview];
                    rect.origin.y += self.view.top;
                    
                    Shop *shop = info[@"shop"];
                    ShopViewController *shopViewController =[[ShopViewController alloc] initWithShop:shop];
                    shopViewController.presentedRect = rect;
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shopViewController];
                    nav.transitioningDelegate = shopViewController;
                    nav.modalPresentationStyle = UIModalPresentationCustom;
                    [self presentViewController:nav animated:YES completion:nil];
                };
            }
            
            if ([self.otherActivities count] > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateActivities:self.otherActivities];
                });
            }
        }
    }];
}

- (void)updateActivities:(NSArray *)activities
{
    NSMutableArray *mutableItems = [NSMutableArray array];
    
    [mutableItems addObject:@[self.activityDetailItem]];
    [mutableItems addObject:activities];
    [self _setItems:mutableItems];
    [self.tableView beginUpdates];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    
    [self.tableView.header endRefreshing];
}

- (void)updateCardViewWithImage:(UIImage *)image desc:(NSString *)desc
{
    [UIView transitionWithView:self.cardImage.superview duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.cardImage.image = image;
        self.imageDescLabel.text = desc;
        self.imageIndexLabel.text = [NSString stringWithFormat:@"%ld / %lu", (long)(self.imageIndex + 1), (unsigned long)self.imageFileIds.count];
    } completion:nil];
}

- (void)convertFilesToImages:(NSArray *)imageIds
{
    for (NSString *imageId in imageIds) {
        [AVFile getFileWithObjectId:imageId withBlock:^(AVFile *file, NSError *error) {
            NSString *imageDesc = [file.name stringByDeletingPathExtension];
            if (imageDesc.length == 0) {
                imageDesc = @"让我们更美的去生活。";
            }
            
            NSData *imageData = [file getData:nil];
            UIImage *image = [UIImage imageWithData:imageData];
            
            if (image) {
                if ([imageId isEqualToString:self.imageFileIds[0]]) {
                    [self.images insertObject:image atIndex:0];
                    [self.imagesDesc insertObject:imageDesc atIndex:0];
                    [self updateCardViewWithImage:image desc:imageDesc];
                } else {
                    [self.images addObject:image];
                    [self.imagesDesc addObject:imageDesc];
                }
            }
        }];
    }
}

- (void)pressedAcceptButton:(UIButton *)button
{
    ActivityAcceptViewController *vc = [[ActivityAcceptViewController alloc] init];
    CGRect rect = [self.view convertRect:button.frame fromView:self.bottomView];
    rect.origin.y += self.view.top;
    vc.presentedRect = rect;
    vc.transitioningDelegate = vc;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -
#pragma mark tableview datasource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.width = self.view.width;
        view.height = [self tableView:self.tableView heightForHeaderInSection:section];
        view.backgroundColor = self.tableView.backgroundColor;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"其他活动";
        label.font = SystemFontWithSize(16);
        label.textColor = RGBCOLOR_HEX(0x969696);
        [view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view).offset(12);
        }];
        
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 1 ? 40 : 0;
}

#pragma mark -
#pragma mark setters and getters

- (UIView *)cardView
{
    UIView *viewContainer = [[UIView alloc] init];
    viewContainer.layer.shadowOffset = CGSizeMake(0, 1);
    viewContainer.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    viewContainer.layer.shadowOpacity = 1;
    viewContainer.backgroundColor = [UIColor whiteColor];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToPreview)];
    tap.numberOfTapsRequired = 1;
    
    [viewContainer addGestureRecognizer:swipeLeft];
    [viewContainer addGestureRecognizer:swipeRight];
    [viewContainer addGestureRecognizer:tap];
    
    UIImageView *cardImageView = [[UIImageView alloc] init];
    cardImageView.clipsToBounds = YES;
    cardImageView.contentMode = UIViewContentModeScaleAspectFill;
    [viewContainer addSubview:cardImageView];
    
    self.cardImage = cardImageView;
    
    [cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(viewContainer);
        make.height.equalTo(cardImageView.mas_width).multipliedBy(540.0f / 600.0f);
    }];
    
    self.imageIndexLabel = [[UILabel alloc] init];
    self.imageIndexLabel.font = SystemFontWithSize(17);
    self.imageIndexLabel.textColor = [UIColor whiteColor];
    self.imageIndexLabel.shadowColor = [UIColor blackColor];
    self.imageIndexLabel.shadowOffset = CGSizeMake(0, 1);
    [self.cardImage addSubview:self.imageIndexLabel];
    
    [self.imageIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cardImageView);
        make.bottom.equalTo(cardImageView).offset(-12);
    }];
    
    UIView *labelView = [[UIView alloc] init];
    [viewContainer addSubview:labelView];
    
    [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardImageView.mas_bottom);
        make.left.and.right.and.bottom.equalTo(viewContainer);
        make.height.equalTo(@100);
    }];
    
    UILabel *imageDescription = [[UILabel alloc] init];
    imageDescription.lineBreakMode = NSLineBreakByWordWrapping;
    imageDescription.numberOfLines = 0;
    imageDescription.font = SystemFontWithSize(14);
    imageDescription.textColor = RGBCOLOR_HEX(0x646464);
    [labelView addSubview:imageDescription];
    
    self.imageDescLabel = imageDescription;
    
    [imageDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(labelView).insets(UIEdgeInsetsMake(20, 10, 20, 10));
    }];
    
    return viewContainer;
}

- (NSArray *)imageFileIds
{
    if (!_imageFileIds) {
        _imageFileIds = self.activities.pics;
    }
    return _imageFileIds;
}

- (UIView *)tableHeaderView
{
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = RGBCOLOR_HEX(0xf7f7f7);
    
    UIView *titleView = [self titleView];
    [containerView addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(containerView);
        make.height.equalTo(@40);
    }];
    
    UIView *cardView = [self cardView];
    [containerView addSubview:cardView];
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom);
        make.bottom.equalTo(containerView).offset(-10);
        make.width.equalTo(@(SCREEN_WIDTH - 10 * 2));
        make.centerX.equalTo(containerView);
    }];
    
    [cardView addSubview:self.shopIcon];
    [self.shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@50);
        make.centerX.equalTo(cardView);
        make.centerY.equalTo(cardView.mas_top);
    }];
    
    weakSelf();
    [self.activities.shop loadShopIcon:^(UIImage *image, NSError *error) {
        weakSelf.shopIcon.image = image;
    }];
    
    return containerView;
}

- (UIView *)titleView
{
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    
    UILabel *shopName = [[UILabel alloc] init];
    shopName.font = SystemFontWithSize(13);
    shopName.textColor = RGBCOLOR_HEX(0xac9456);
    shopName.text = self.activities.shop.shopname;
    [titleView addSubview:shopName];
    
    [shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView);
        make.left.equalTo(titleView).offset(10);
    }];
    
    UILabel *distanceLable = [[UILabel alloc] init];
    distanceLable.font = SystemFontWithSize(12);
    distanceLable.textColor = [UIColor blackColor];
    [titleView addSubview:distanceLable];
    
    AVGeoPoint *geo = self.activities.shop.geolocation;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:geo.latitude longitude:geo.longitude];
    [[LYLocationManager sharedManager] getCurrentLocation:^(BOOL success, CLLocation *currentLocation) {
        if (success) {
            CLLocationDistance distance = [currentLocation distanceFromLocation:location];
            double distanceInKM = distance / 1000.0;
            distanceLable.text = [NSString stringWithFormat:@"%.1fkm", distanceInKM];
        }
    }];
    
    [distanceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(shopName);
        make.right.equalTo(titleView).offset(-10);
    }];
    
    UIImageView *locationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Location"]];
    [titleView addSubview:locationView];
    
    [locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(distanceLable);
        make.right.equalTo(distanceLable.mas_left).offset(-4);
    }];
    
    return titleView;
}

- (NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray arrayWithCapacity:0];
    }
    return _images;
}

- (NSMutableArray *)imagesDesc
{
    if (!_imagesDesc) {
        _imagesDesc = [NSMutableArray arrayWithCapacity:0];
    }
    return _imagesDesc;
}

- (void)setImageIndex:(NSInteger)imageIndex
{
    if (imageIndex < 0) {
        imageIndex = self.imageFileIds.count - 1;
    } else if (imageIndex >= self.imageFileIds.count) {
        imageIndex = 0;
    }
    _imageIndex = imageIndex;
    if (imageIndex < self.images.count) {
        [self updateCardViewWithImage:self.images[imageIndex] desc:self.imagesDesc[imageIndex]];
    }
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = DefaultYellowColor;
    }
    return _bottomView;
}

- (UIButton *)acceptButton
{
    if (!_acceptButton) {
        _acceptButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_acceptButton addTarget:self action:@selector(pressedAcceptButton:) forControlEvents:UIControlEventTouchUpInside];
        [_acceptButton setTitle:@"接受" forState:UIControlStateNormal];
        _acceptButton.titleLabel.font = SystemFontWithSize(16);
        _acceptButton.tintColor = [UIColor whiteColor];
//        _acceptButton.backgroundColor = RGBCOLOR(180, 160, 80);
        
//        _acceptButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:.7].CGColor;
//        _acceptButton.layer.borderWidth = 1;
//        _acceptButton.layer.cornerRadius = 2;
    }
    return _acceptButton;
}

- (UIImageView *)shopIcon
{
    if (!_shopIcon) {
        _shopIcon = [[UIImageView alloc] init];
        _shopIcon.contentMode = UIViewContentModeScaleAspectFill;
        _shopIcon.clipsToBounds = YES;
        _shopIcon.userInteractionEnabled = YES;
        _shopIcon.layer.cornerRadius = 25;
        _shopIcon.layer.borderWidth = 2;
        _shopIcon.layer.borderColor = RGBCOLOR(238, 238, 238).CGColor;
        weakSelf();
        [_shopIcon bk_whenTapped:^{
            CGRect rect = [weakSelf.view convertRect:weakSelf.shopIcon.frame fromView:weakSelf.shopIcon.superview];
            rect.origin.y += weakSelf.view.top;
            
            ShopViewController *shopViewController =[[ShopViewController alloc] initWithShop:weakSelf.activities.shop];
            shopViewController.presentedRect = rect;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shopViewController];
            nav.transitioningDelegate = shopViewController;
            nav.modalPresentationStyle = UIModalPresentationCustom;
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }];
    }
    return _shopIcon;
}

#pragma mark -
#pragma mark gesture

- (void)swipeLeft
{
    self.imageIndex++;
}

- (void)swipeRight
{
    self.imageIndex--;
}

- (void)tapToPreview
{
    if ([self.images count] < [self.imageFileIds count]) {
        return;//图片还没获取完成
    }
    ImagePreviewViewController *previewVC = [[ImagePreviewViewController alloc] init];
    previewVC.transitioningDelegate = previewVC;
    previewVC.modalPresentationStyle = UIModalPresentationCustom;
    previewVC.images = self.images;
    previewVC.currentIndex = self.imageIndex;
    
    [self presentViewController:previewVC animated:YES completion:nil];
}

@end
