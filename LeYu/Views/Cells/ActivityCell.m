//
//  ActivityCell.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/6/20.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ActivityCell.h"
#import "ShopActivities.h"
#import "LYLocationManager.h"

static const CGFloat kContentInset = 20;

static const CGFloat titleVerticalGap = 10;

@interface ActivityCell()

@property (nonatomic, strong) UIImageView *styleImageView;
@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UIImageView *locationView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *topView;

@end

@implementation ActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [UIView transitionWithView:self.backView duration:.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (highlighted) {
            self.backView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
        } else {
            self.backView.backgroundColor = [UIColor whiteColor];
        }
    } completion:nil];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
//    self.transform = CGAffineTransformMakeScale(1.2, 1.2);
//    self.alpha = 0;
//    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.alpha = 1;
//        self.transform = CGAffineTransformIdentity;
//    } completion:nil];
}

- (void)initSubviews
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = SystemFontWithSize(14);
    self.titleLabel.preferredMaxLayoutWidth = self.contentView.width - kContentInset * 2;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textColor = RGBCOLOR_HEX(0x888888);
    
    self.thumbnailImage = [[UIImageView alloc] init];
    self.thumbnailImage.clipsToBounds = YES;
    
    self.styleImageView = [[UIImageView alloc] init];
    self.styleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.thumbnailImage addSubview:self.styleImageView];
    
    self.shopIcon = [[UIImageView alloc] init];
    self.shopIcon.image = [UIImage imageNamed:@"The news"];
    self.shopIcon.clipsToBounds = YES;
    self.shopIcon.userInteractionEnabled = YES;
    self.shopIcon.contentMode = UIViewContentModeScaleAspectFill;
    self.shopIcon.layer.borderWidth = 2;
    self.shopIcon.layer.borderColor = RGBCOLOR(238, 238, 238).CGColor;
    self.shopIcon.layer.cornerRadius = 25;
    self.shopIcon.layer.allowsEdgeAntialiasing = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigateToShopPage)];
    [self.shopIcon addGestureRecognizer:tap];
    
    self.shopNameLabel = [[UILabel alloc] init];
    self.shopNameLabel.font = SystemFontWithSize(12);
    self.shopNameLabel.textColor = RGBCOLOR_HEX(0xbbbbbb);
    
    self.giftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Package"]];
    self.giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.giftNumberLabel = [[UILabel alloc] init];
    self.giftNumberLabel.font = self.shopNameLabel.font;
    self.giftNumberLabel.textColor = [UIColor grayColor];
    
//    self.locationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Location"]];
//    self.locationView.contentMode = UIViewContentModeScaleAspectFill;
//    
//    self.distanceLabel = [[UILabel alloc] init];
//    self.distanceLabel.textAlignment = NSTextAlignmentRight;
//    self.distanceLabel.font = SystemFontWithSize(13);
//    self.distanceLabel.textColor = RGBCOLOR_HEX(0x1f1f1f);
    
    self.bottomView = [[UIView alloc] init];
    
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = RGBCOLOR_HEX(0xfafafa);
//    self.backView.clipsToBounds = YES;
    
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.thumbnailImage];
    [self.backView addSubview:self.shopIcon];
    [self.backView addSubview:self.shopNameLabel];
//    [self.contentView addSubview:self.giftImageView];
//    [self.contentView addSubview:self.giftNumberLabel];
    [self.backView addSubview:self.locationView];
    [self.backView addSubview:self.distanceLabel];
    [self.contentView addSubview:self.bottomView];
    
//    self.backView.layer.cornerRadius = 5;
//    self.backView.layer.borderWidth = 1;
//    self.backView.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:0.6].CGColor;
    self.backView.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(0, 0);
    self.backView.layer.shadowOpacity = 1;
    self.backView.layer.shadowRadius = 3;
    
    [self setupConstraints];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setupConstraints
{
    UIView *superview = self.backView;
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView);
//        make.left.equalTo(self.contentView).offset(titleVerticalGap);
//        make.right.equalTo(self.contentView).offset(-titleVerticalGap);
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.bottomView.mas_top);
//        make.bottom.equalTo(self.contentView).offset(-kContentInset);
    }];
    
    [self.thumbnailImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(superview);
        make.height.equalTo(@(SCREEN_WIDTH * 9.0 / 16.0));
    }];
    
    [self.styleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thumbnailImage).offset(20);
        make.top.equalTo(self.thumbnailImage).offset(20);
    }];
    
    [self.shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(50.0f));
        make.height.equalTo(@(50.0f));
        make.left.equalTo(superview).offset(kContentInset);
        make.centerY.equalTo(self.thumbnailImage.mas_bottom);
    }];
    
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopIcon.mas_right).offset(kContentInset/4);
        make.bottom.equalTo(self.shopIcon);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopIcon.mas_bottom).with.offset(titleVerticalGap);
        make.left.equalTo(self.shopIcon);
        make.right.equalTo(self.backView).offset(-kContentInset);
//        make.right.lessThanOrEqualTo(self.locationView.mas_left).offset(-kContentInset/2);
        make.bottom.equalTo(superview).with.offset(-titleVerticalGap);
    }];
    
//    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.titleLabel);
//        make.right.equalTo(self.giftNumberLabel.mas_left).offset(- kContentInset / 4);
//    }];
//    
//    [self.giftNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(superview).with.offset(-kContentInset);
//        make.centerY.equalTo(self.giftImageView);
//    }];
    
//    [self.distanceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(superview).with.offset(-kContentInset/2);
//        make.centerY.equalTo(self.titleLabel);
//    }];
//    
//    [self.locationView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.distanceLabel);
//        make.right.equalTo(self.distanceLabel.mas_left).offset(- kContentInset / 4);
//    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.backView.mas_bottom);
        make.height.equalTo(@(titleVerticalGap));
    }];
}

- (void)setCellItem:(ShopActivities *)cellItem
{
    [super setCellItem:cellItem];
    [self configureCellWithActivity:cellItem];
    if (cellItem.shop) {
        self.shopIcon.hidden = NO;
        self.shopNameLabel.hidden = NO;
        [self configureShopWithShop:cellItem.shop];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.shopIcon.mas_bottom).with.offset(titleVerticalGap);
            make.bottom.equalTo(self.backView).with.offset(-titleVerticalGap);
            make.left.equalTo(self.shopIcon);
            make.right.equalTo(self.backView).offset(-kContentInset);
        }];
    } else {
        self.shopNameLabel.hidden = YES;
        self.shopIcon.hidden = YES;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.thumbnailImage.mas_bottom).offset(titleVerticalGap);
            make.left.equalTo(self.shopIcon);
            make.bottom.equalTo(self.backView).with.offset(-titleVerticalGap);
            make.right.equalTo(self.backView).offset(-kContentInset);
        }];
    }
}

- (void)configureCellWithActivity:(ShopActivities *)activity
{
    self.titleLabel.text = activity.title;
    if (activity.cached) {
        self.thumbnailImage.contentMode = UIViewContentModeScaleAspectFill;
        self.thumbnailImage.image = activity.thumbnail;
    } else {
        self.thumbnailImage.contentMode = UIViewContentModeCenter;
        self.thumbnailImage.image = [UIImage imageNamed:@"placeholder"];
        
        [activity getActivityThumbNail:^(UIImage *image, NSError *error) {
            [UIView transitionWithView:self duration:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.thumbnailImage.contentMode = UIViewContentModeScaleAspectFill;
                self.thumbnailImage.image = image;
            } completion:nil];
        }];
    }
    
    NSString *imageName = nil;
    if ([activity.activityType integerValue] == ActivityTypeNormal) {
        imageName = @"他们说";
    } else {
        if (activity.shop) {
            imageName = @"boutique";
        } else {
            imageName = @"生活+";
        }
    }
    self.styleImageView.image = [UIImage imageNamed:imageName];
    

    self.distanceLabel.text = @"--km";
    
//    AVGeoPoint *geo = activity.shop.geolocation;
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:geo.latitude longitude:geo.longitude];
//    [[LYLocationManager sharedManager] getCurrentLocation:^(BOOL success, CLLocation *currentLocation) {
//        if (success) {
//            CLLocationDistance distance = [currentLocation distanceFromLocation:location];
//            double distanceInKM = distance / 1000.0;
//            self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm", distanceInKM];
//        }
//    }];
}

- (void)configureShopWithShop:(Shop *)shop
{
    [shop loadShopIcon:^(UIImage *image, NSError *error) {
        self.shopIcon.image = image;
    }];
    self.shopNameLabel.text = shop.shopname;
}

- (void)navigateToShopPage
{
    if (self.cellItem.handleBlock) {
        self.cellItem.handleBlock(@{@"sender" : self.shopIcon,
                                    @"description" : @"shop Selected"});
    }
}

@end
