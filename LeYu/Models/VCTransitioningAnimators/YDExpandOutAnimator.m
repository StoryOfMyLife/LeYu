//
//  YDExpandOutAnimator.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/8/4.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "YDExpandOutAnimator.h"

@implementation YDExpandOutAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         fromVC.view.alpha = 0.0f;
                         fromVC.view.transform = CGAffineTransformMakeScale(2, 2);
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
