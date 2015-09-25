//
//  IntroViewController.m
//  CSAcademy
//
//  Created by 刘廷勇 on 15/6/24.
//  Copyright (c) 2015年 liuty. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroLastView : UIView
@property (weak, nonatomic) IBOutlet UIButton *denyButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@end

@implementation IntroLastView


@end

@interface IntroViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *lastImageView;

@end

@implementation IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    NSArray *imageArray = @[@"引导页1", @"引导页2", @"引导页3"];
    
    self.scrollView.contentSize = CGSizeMake(self.view.width * imageArray.count, self.view.height);
    
    for (NSInteger i = 0; i < [imageArray count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.scrollView.width, 0, self.scrollView.width, self.scrollView.height)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageNamed:imageArray[i]];
        
        if (i == [imageArray count] - 1) {
            self.lastImageView = imageView;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [self.lastImageView addGestureRecognizer:tap];
            self.lastImageView.userInteractionEnabled = YES;
        }
        
        [self.scrollView addSubview:imageView];
    }
}

- (void)tap:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"intro"];
    }];
}


@end
