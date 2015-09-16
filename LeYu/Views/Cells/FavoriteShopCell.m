//
//  FavoriteShopCell.m
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/16.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "FavoriteShopCell.h"
#import "Shop.h"
#import "StringFactory.h"

@interface FavoriteShopCell()

@property (nonatomic,strong) UIImageView *shopimageView;

@property (nonatomic,strong) UIImageView *thumbnail;

@property (nonatomic,strong) UILabel* nameLabel;

@property (nonatomic,strong) UIView *footerView;

@end

@implementation FavoriteShopCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.shopimageView = [[UIImageView alloc] init];
        self.shopimageView.clipsToBounds = YES;
        self.shopimageView.contentMode =UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.shopimageView];
        
        
        self.thumbnail = [[UIImageView alloc] init];
        self.thumbnail.clipsToBounds = YES;
        self.thumbnail.contentMode = UIViewContentModeScaleAspectFill;
        [self.thumbnail.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.thumbnail.layer setBorderWidth:2.5f];
        [self.contentView addSubview:self.thumbnail];
        
        self.nameLabel =[[UILabel alloc] init];
        self.nameLabel.font = [UIFont fontWithName:@"Baskerville" size:15.0f];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.nameLabel];
        
        self.footerView = [[UIView alloc] init];
        self.footerView.backgroundColor = UIColorFromRGB(0xF7F7F7);
        [self.contentView addSubview:self.footerView];
        
        [self setupConstraints];
        
    }
    return self;
    
    
}

-(void)setupConstraints{
    WeakSelf weakSelf = self;
   [self.thumbnail mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(weakSelf.contentView).with.offset(15.0f);
       make.left.equalTo(weakSelf.contentView).with.offset(15.0f);
       make.centerY.equalTo(weakSelf.shopimageView.mas_top);
       make.height.equalTo(@(60.0f));
       make.width.equalTo(@(60.0f));
   }];
    
  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(weakSelf.thumbnail.mas_top);
      make.bottom.equalTo(weakSelf.shopimageView.mas_top);
      make.left.equalTo(weakSelf.thumbnail.mas_right).with.offset(10.0f);
      make.right.equalTo(weakSelf.contentView.mas_right);
  }];
    
  [self.shopimageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(weakSelf.footerView.mas_top);
      make.left.equalTo(weakSelf.contentView.mas_left);
      make.right.equalTo(weakSelf.contentView.mas_right);
  }];
    
  [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(weakSelf.shopimageView.mas_bottom);
      make.left.equalTo(weakSelf.contentView.mas_left);
      make.right.equalTo(weakSelf.contentView.mas_right);
      make.bottom.equalTo(weakSelf.contentView.mas_bottom);
      make.height.equalTo(@(15.0f));
  }];

}


-(void)configureCell:(Shop *)shop {
    
    [shop loadShopIcon:^(UIImage *image, NSError *error) {
        self.thumbnail.image = image;
    }];
    
    
    AVFile *background = shop.shopbackground;
    if (background) {
        [background getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                self.shopimageView.image = [UIImage imageWithData:data];
            }
        }];
    }
    
    NSString *shopName = shop.shopname;
    if (![StringFactory isEmptyString:shopName]) {
        self.nameLabel.text = shopName;
    }

}



@end
