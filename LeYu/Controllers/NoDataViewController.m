//
//  NoDataViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/23.
//  Copyright © 2015年 liuty. All rights reserved.
//

#import "NoDataViewController.h"

@interface NoDataViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation NoDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setInfo:(NSString *)info
{
    if (![_info isEqualToString:info]) {
        _info = info;
        self.infoLabel.text = info;
    }
}

- (void)viewWillLayoutSubviews
{
    self.infoLabel.text = self.info;
}

@end
