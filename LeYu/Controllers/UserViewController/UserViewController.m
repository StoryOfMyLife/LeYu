//
//  UserViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/9/19.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfoEditViewController.h"
#import "SettingViewController.h"
#import "ShopActivityViewController.h"
#import <FXBlurView.h>

@interface UserViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (nonatomic, strong) UIMotionEffectGroup *motionEffect;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = DefaultBackgroundColor;

    self.avatar.layer.cornerRadius = 30;
    self.avatar.layer.borderWidth = 1;
    self.avatar.layer.borderColor = RGBACOLOR(238, 238, 238, 0.7).CGColor;
    
    self.name.text = [LYUser currentUser].username;
    
    [self updateAvatar];
    
    [self.avatar addMotionEffect:self.motionEffect];
    [self.name addMotionEffect:self.motionEffect];
    [self.editButton addMotionEffect:self.motionEffect];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:[LYUser currentUser] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }
    }
}

#pragma mark -
#pragma mark methods

- (void)updateAvatar
{
    if ([LYUser currentUser]) {
        [[LYUser currentUser].thumbnail getThumbnail:YES width:120 height:120 withBlock:^(UIImage *image, NSError *error) {
            if (!error) {
                UIImage *blurredImage = [image blurredImageWithRadius:5 iterations:5 tintColor:nil];
                [UIView transitionWithView:self.tableView.tableHeaderView duration:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    self.backImage.image = blurredImage;
                    self.avatar.image = image;
                } completion:nil];
            }
        }];
    } else {
        [UIView transitionWithView:self.tableView.tableHeaderView duration:.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.backImage.image = [UIImage imageNamed:@"背景"];
            self.avatar.image = [UIImage imageNamed:@"DefaultAvatar"];
        } completion:nil];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[UserInfoEditViewController class]]) {
        UserInfoEditViewController *destVC = segue.destinationViewController;
        destVC.shopUser = self.isShopUser;
        destVC.userVC = self;
    } else if ([segue.destinationViewController isKindOfClass:[SettingViewController class]]) {
        SettingViewController *setVC = segue.destinationViewController;
        setVC.userVC = self;
    }
}

#pragma mark -
#pragma mark accessors

- (UIMotionEffectGroup *)motionEffect
{
    if (!_motionEffect) {
        _motionEffect = [[UIMotionEffectGroup alloc] init];
        
        UIInterpolatingMotionEffect *motionX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionX.minimumRelativeValue = @(-20);
        motionX.maximumRelativeValue = @(20);
        
        UIInterpolatingMotionEffect *motionY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionY.minimumRelativeValue = @(-15);
        motionY.maximumRelativeValue = @(10);
        
        _motionEffect.motionEffects = @[motionX, motionY];
    }
    return _motionEffect;
}

@end
