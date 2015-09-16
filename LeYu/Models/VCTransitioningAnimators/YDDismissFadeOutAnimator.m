//
//  YDDismissFadeOutAnimator.m
//  VCTransitionDemo
//
//  Created by 刘廷勇 on 15/1/24.
//  Copyright (c) 2015年 Netease Youdao. All rights reserved.
//

#import "YDDismissFadeOutAnimator.h"

@implementation YDDismissFadeOutAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewKeyframeAnimationOptionBeginFromCurrentState
                     animations:^{
                         fromVC.view.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
