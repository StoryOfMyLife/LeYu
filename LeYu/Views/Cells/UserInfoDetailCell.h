//
//  UserInfoDetailCell.h
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/2.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoDetailCell : UITableViewCell

-(void)configureText:(NSString *)text;

-(void)configureImage:(AVFile *)dataFile;

@end
