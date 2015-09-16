//
//  UserInfoDetailCell.m
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/2.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "UserInfoDetailCell.h"

@interface UserInfoDetailCell()

@property (nonatomic,strong) UILabel *label;

@property (nonatomic,strong) UIImageView *thumbnail;


@end

@implementation UserInfoDetailCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentRight;
        self.label.numberOfLines =1;
        
        
        self.thumbnail = [[UIImageView alloc] init];
        self.thumbnail.contentMode = UIViewContentModeScaleAspectFit;
        self.thumbnail.clipsToBounds = YES;
        self.thumbnail.image = [UIImage imageNamed:@"DefaultAvatar"];
        
        
    }
    return self;
}


-(void)configureText:(NSString *)text {
    [self.contentView addSubview:self.label];
    WeakSelf weakSelf = self;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-5.0f);
        make.width.equalTo(weakSelf.contentView.mas_width).dividedBy(3);
        make.top.equalTo(weakSelf.contentView.mas_top);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
    }];
    self.label.text = text;

}

-(void)configureImage:(AVFile *)dataFile {
    WeakSelf weakSelf = self;
    [self.contentView addSubview:self.thumbnail];
    [self.thumbnail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).with.offset(-5.0f);
        make.width.equalTo(@(50.0f));
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.height.equalTo(@(50.0f));
        
    }];
    [dataFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(!error){
            self.thumbnail.image  = [UIImage imageWithData:data];
        }

    }];
    
}
         
-(void)prepareForReuse {
    [super prepareForReuse];
    self.textLabel.text =nil;
    self.imageView.image = nil;
    [self.imageView removeFromSuperview];
    [self.label removeFromSuperview];
}

@end
