//
//  OtherActivityCellItem.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/9/7.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "OtherActivityCell.h"
#import "ShopActivities.h"
#import "LYLocationManager.h"
#import "ActivityUserRelation.h"

@implementation OtherActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
//        self.layer.shadowOffset = CGSizeMake(0, 0);
//        self.layer.shadowOpacity = 1;
//        self.layer.shadowRadius = 3;
        
        self.imageIconView = [[UIImageView alloc] init];
        self.imageIconView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageIconView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageIconView];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.textColor = DefaultTitleColor;
        self.titleLabel.font = SystemFontWithSize(16);
        [self.contentView addSubview:self.titleLabel];
        
        self.styleImageView = [[UIImageView alloc] init];
        self.styleImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.styleImageView];
        
//        UIImageView *locationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Location"]];
//        locationView.contentMode = UIViewContentModeScaleAspectFill;
//        [self.contentView addSubview:locationView];
        
        self.distanceLabel = [[UILabel alloc] init];
        self.distanceLabel.textAlignment = NSTextAlignmentRight;
        self.distanceLabel.font = SystemFontWithSize(13);
        self.distanceLabel.textColor = RGBCOLOR_HEX(0x1f1f1f);
        [self.contentView addSubview:self.distanceLabel];
        
        UIView *seperator = [[UIView alloc] init];
        seperator.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:seperator];
        
        CGFloat inset = 10;
        
        [self.imageIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(inset);
            make.top.equalTo(self.contentView).offset(inset);
            make.bottom.equalTo(self.contentView).offset(-inset);
            make.height.equalTo(@70);
            make.width.equalTo(@(70.0 * 16.0 / 10.0));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageIconView.mas_right).offset(inset * 2);
            make.right.equalTo(self.contentView).offset(- inset * 2);
            make.top.equalTo(self.contentView).offset(inset);
//            make.bottom.equalTo(self.contentView.mas_centerY).offset(-inset);
        }];
        
//        [locationView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.titleLabel);
//            make.top.equalTo(self.contentView.mas_centerY).offset(inset);
//        }];
        
        [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.bottom.equalTo(self.contentView).offset(-inset);
        }];
        
        [self.styleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-inset * 2);
            make.bottom.equalTo(self.distanceLabel);
        }];
        
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageIconView);
            make.height.mas_equalTo(0.5);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        
        self.arrivedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrived"]];
        self.arrivedImage.contentMode = UIViewContentModeScaleAspectFill;
        self.arrivedImage.hidden = YES;
        [self.contentView addSubview:self.arrivedImage];
        
        [self.arrivedImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [UIView transitionWithView:self duration:.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (highlighted) {
            self.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
        } else {
            self.contentView.backgroundColor = [UIColor whiteColor];
        }
    } completion:nil];
}

- (void)setCellItem:(ShopActivities *)cellItem
{
    [super setCellItem:cellItem];
    [self configureCellWithActivity:cellItem];
    
    self.titleLabel.text = cellItem.title;
    
    if (cellItem.style == OtherActivityStyleNearby) {
        self.distanceLabel.hidden = NO;
    } else if (cellItem.style == OtherActivityStyleRecent) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY.MM.dd";
        self.distanceLabel.text = [formatter stringFromDate:cellItem.createdAt];
    } else {
        self.distanceLabel.hidden = YES;
    }
    
    if ([LYUser currentUser]) {
        AVQuery *query = [ActivityUserRelation query];
        [query whereKey:@"user" equalTo:[LYUser currentUser]];
        [query whereKey:@"activity" equalTo:cellItem];
        
        [query getFirstObjectInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            if ([object isKindOfClass:[ActivityUserRelation class]]) {
                ActivityUserRelation *relation = (ActivityUserRelation *)object;
                if (relation.isArrived) {
                    self.arrivedImage.hidden = NO;
                } else {
                    self.arrivedImage.hidden = YES;
                }
            }
        }];
    }
    
    if (cellItem.style == OtherActivityStyleNearby) {
        AVGeoPoint *geo = cellItem.shop.geolocation;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:geo.latitude longitude:geo.longitude];
        [[LYLocationManager sharedManager] getCurrentLocation:^(BOOL success, CLLocation *currentLocation) {
            if (success) {
                CLLocationDistance distance = [currentLocation distanceFromLocation:location];
                double distanceInKM = distance / 1000.0;
                self.distanceLabel.text = [NSString stringWithFormat:@"%.1fkm", distanceInKM];
            }
        }];
    }
}

- (void)configureCellWithActivity:(ShopActivities *)activity
{
    BOOL cached = activity.cached;
    [activity getActivityThumbNail:^(UIImage *image, NSError *error) {
        [UIView transitionWithView:self duration:cached ? 0 : .3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.imageIconView.image = image;
        } completion:nil];
    }];
    
    NSString *imageName = nil;
    if ([activity.activityType integerValue] == ActivityTypeNormal) {
        imageName = @"他们说2";
    } else {
        if (activity.shop) {
            imageName = @"boutique2";
        } else {
            imageName = @"生活+2";
        }
    }
    self.styleImageView.image = [UIImage imageNamed:imageName];
}

@end