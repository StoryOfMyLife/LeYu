//
//  ShopMapCellItem.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/16.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "ShopMapCellItem.h"
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@implementation ShopMapCellItem

- (Class)cellClass
{
    return [ShopMapCell class];
}

@end


@interface ShopMapCell ()

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) UILabel *address;

@property (nonatomic, strong) UIView *wrapperView;

@end

@implementation ShopMapCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.address = [[UILabel alloc] init];
        self.address.numberOfLines = 0;
        self.address.textAlignment = NSTextAlignmentCenter;
        self.address.font = SystemFontWithSize(15);
        self.address.textColor = DefaultTitleColor;
        [self.address setPreferredMaxLayoutWidth:[UIScreen mainScreen].bounds.size.width-20.0f];
        
        [self.contentView addSubview:self.address];
        
        self.mapView = [[MKMapView alloc] init];
        [self.contentView addSubview:self.mapView];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    CGFloat inset = 20.0f;
    
    [self.address mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(inset);
        make.centerX.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-inset);
    }];
    
    [self.mapView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.address.mas_bottom).with.offset(inset);
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@(300));
    }];
}

- (void)setCellItem:(ShopMapCellItem *)cellItem
{
    [super setCellItem:cellItem];
    Shop *shop = cellItem.shop;
    NSString *prefix = @"地点:  ";
    NSString *addressString;
    if (shop.address) {
        addressString= [prefix stringByAppendingString:shop.address];
    }
    self.address.text = addressString;
    CLLocationCoordinate2D coordinate;
    
    coordinate.latitude = shop.geolocation.latitude;
    coordinate.longitude = shop.geolocation.longitude;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    
    [self.mapView setRegion:region animated:YES];
    [self.mapView addAnnotation:annotation];
}

@end
