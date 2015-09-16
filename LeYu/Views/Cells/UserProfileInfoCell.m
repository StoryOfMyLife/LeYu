//
//  UserProfileInfoCell.m
//  LifeO2O
//
//  Created by jiecongwang on 7/12/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "UserProfileInfoCell.h"
#import "ImageFactory.h"

@interface UserProfileInfoCell()

@property (nonatomic,strong) UIImageView *thumbnail;

@property (nonatomic,strong) UILabel *username;

@property (nonatomic,strong) UILabel *personalDescription;



@end


@implementation UserProfileInfoCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.thumbnail = [[UIImageView alloc] init];
        self.thumbnail.contentMode = UIViewContentModeScaleAspectFit;
        self.thumbnail.clipsToBounds = YES;
        self.thumbnail.image = [ImageFactory getImages:@"DefaultAvatar"];
        [self.contentView addSubview:self.thumbnail];
        
        self.userInfoWrapperView = [[UIView alloc] init];
        [self.contentView addSubview:self.userInfoWrapperView];
        
        self.username = [[UILabel alloc] init];
        self.username.font = [UIFont fontWithName:@"Baskerville" size:28.0f];
        self.username.textColor = UIColorFromRGB(0x000000);
        self.username.numberOfLines = 0;
        self.username.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.userInfoWrapperView addSubview:self.username];
        
        self.personalDescription = [[UILabel alloc] init];
        self.personalDescription.font = [UIFont fontWithName:@"Baskerville" size:19.0f];
        self.personalDescription.textColor = UIColorFromRGB(0xAAAAAA);
        self.personalDescription.numberOfLines = 0;
        self.personalDescription.lineBreakMode = NSLineBreakByWordWrapping;
        [self.userInfoWrapperView addSubview:self.personalDescription];
        [self setUpConstraints];
        
    }
    return self;
}


-(void)setUpConstraints{
    WeakSelf weakself =self;
    [self.thumbnail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.contentView.mas_centerY);
        make.height.equalTo(@(80.0f));
        make.width.equalTo(@(80.0f));
        make.left.equalTo(weakself.contentView.mas_left).with.offset(15.0f);
    }];
    
    
    [self.userInfoWrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.contentView.mas_centerY);
        make.left.equalTo(weakself.thumbnail.mas_right).with.offset(10.0f);
        make.right.equalTo(weakself.contentView.mas_right).with.offset(5.0f);

    }];
    
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.userInfoWrapperView.mas_top);
        make.left.equalTo(weakself.userInfoWrapperView.mas_left);
        make.right.equalTo(weakself.userInfoWrapperView.mas_right);
    }];
    
    [self.username setPreferredMaxLayoutWidth:[UIScreen mainScreen].bounds.size.width - 80.0f];
    
    [self.personalDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.username.mas_bottom).with.offset(5);
        make.left.equalTo(weakself.userInfoWrapperView.mas_left);
        make.right.equalTo(weakself.userInfoWrapperView.mas_right);
        make.bottom.equalTo(weakself.userInfoWrapperView.mas_bottom).priorityLow();
    }];
    
    [self.personalDescription setPreferredMaxLayoutWidth:[UIScreen mainScreen].bounds.size.width - 80.0f];
    
}








-(void)configureUser:(LYUser *)user {
    if (![StringFactory isEmptyString:user.username]) {
        self.username.text = user.username;
    }else {
        self.username.text = @"用户名";
    }
    
    if (![StringFactory isEmptyString:user.personalDescription]) {
        self.personalDescription.text = user.personalDescription;
    }else {
        self.personalDescription.text = @"你还没有填写你的个人说明";
    }

    
    AVFile *thumbnail = user.thumbnail;
    if (thumbnail) {
        [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.thumbnail.image = image;
            }
            
        }];
    }
    
    CGFloat height = [self.userInfoWrapperView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
    [self.userInfoWrapperView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    
}

@end
