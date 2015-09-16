//
//  CrossDissolveAnimator.m
//  VCTransitionDemo
//
//  Created by 刘廷勇 on 15/1/23.
//  Copyright (c) 2015年 Netease Youdao. All rights reserved.
//

#import "YDPresentFadeInAnimator.h"

@implementation YDPresentFadeInAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toVC.view.alpha = 0.0f;
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewKeyframeAnimationOptionBeginFromCurrentState
                     animations:^{
                         toVC.view.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
