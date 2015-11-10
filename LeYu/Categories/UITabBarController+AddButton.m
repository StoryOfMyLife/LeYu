 //
//  UITabBarController+AddButton.m
//  LifeO2O
//
//  Created by Jiecong Wang on 15/8/30.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "UITabBarController+AddButton.h"
#import "HFCreateAvtivityViewController.h"
#import <objc/runtime.h>

@implementation UITabBarController (AddButton)

#define UITabBarControllerAddButtonKey @"UITabBarControllerAddButtonKey"

-(void)setAddButton:(UIButton *)addButton {
    UIButton *currentButton = [self addButton];
    
    if (currentButton !=nil) {
        [currentButton removeFromSuperview];
        objc_setAssociatedObject(self, UITabBarControllerAddButtonKey, nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (addButton != nil) {
        objc_setAssociatedObject(self, UITabBarControllerAddButtonKey, addButton,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.tabBar addSubview:addButton];
        
        
        [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            HFCreateAvtivityViewController *picker = [[HFCreateAvtivityViewController alloc] init];
            [self presentViewController:picker animated:YES completion:nil];
        }];
        
        addButton.centerY = 0;
        addButton.centerX = self.tabBar.centerX;
        
//        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.tabBar.mas_centerX);
//            make.centerY.equalTo(self.tabBar.mas_top);
//        }];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIButton *currentButton = [self addButton];
    if (currentButton) {
        [self.tabBar bringSubviewToFront:currentButton];
    }
}

- (UIButton *)addButton {
    UIButton *curAddButton = objc_getAssociatedObject(self, UITabBarControllerAddButtonKey);
    return curAddButton;
}

- (void)showAddButton {
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"add_highlighted"] forState:UIControlStateHighlighted];
    [addButton sizeToFit];
    [self setAddButton:addButton];
}

- (void)hideAddButton {
    [self setAddButton:nil];
}

- (BOOL)showingAddButton {
    UIButton *addButton = [self addButton];
    if (addButton) {
        return YES;
    }
    return NO;
}

@end
