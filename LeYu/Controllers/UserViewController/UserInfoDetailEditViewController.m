//
//  UserInfoDetailEditViewController.m
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/9.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "UserInfoDetailEditViewController.h"
#import "ImageFactory.h"
#import "ColorFactory.h"

@interface UserInfoDetailEditViewController ()

@end

@implementation UserInfoDetailEditViewController



-(void)loadView{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [ColorFactory dyLightGray];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Confirm"] style:UIBarButtonItemStylePlain target:self action:@selector(updateUser)];

}


-(void)updateUser{


}





@end
