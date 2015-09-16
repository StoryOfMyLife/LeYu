//
//  UserProfileInfoCell.h
//  LifeO2O
//
//  Created by jiecongwang on 7/12/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYUser.h"

@interface UserProfileInfoCell : UITableViewCell

-(void)configureUser:(LYUser *)user;

@property (nonatomic,strong) UIView *userInfoWrapperView;


@end
