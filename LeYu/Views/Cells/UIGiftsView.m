//
//  UIGiftsView.m
//  LifeO2O
//
//  Created by jiecongwang on 6/8/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "UIGiftsView.h"
#import "ImageFactory.h"

const CGFloat kPaddingLeft =6.0f;

@interface UIGiftsView()

@property (nonatomic,strong) UILabel *numberOfGifts;

@property (nonatomic,strong) UIImageView *giftsIcon;

@end

@implementation UIGiftsView


-(instancetype) init {
    if (self = [super init]) {
        self.numberOfGifts = [[UILabel alloc] init];
        self.giftsIcon = [[UIImageView alloc] init];
        self.giftsIcon.image = [ImageFactory getImages:@"Package"];
        self.giftsIcon.contentMode =UIViewContentModeScaleAspectFill;
        self.numberOfGifts.textAlignment =NSTextAlignmentLeft;
        self.numberOfGifts.numberOfLines = 1;
        [self addSubview:self.numberOfGifts];
        [self addSubview:self.giftsIcon];
        [self setUpConstraints];
    }
    return self;
}

-(void)setUpConstraints {
    WeakSelf weakSelf =self;
    [self.giftsIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top);
        make.left.mas_equalTo(weakSelf.mas_left);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
        make.width.mas_equalTo(weakSelf.mas_height);
    }];
    
    [self.numberOfGifts mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.giftsIcon.mas_centerY);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.left.mas_equalTo(weakSelf.giftsIcon.mas_right).with.offset(kPaddingLeft);

    }];
}

-(void) setGiftsValue:(NSNumber *)giftsvalue {
    self.numberOfGifts.text = [giftsvalue stringValue];
}

-(void)prepareForUse {
    self.numberOfGifts.text = nil;
}






@end
