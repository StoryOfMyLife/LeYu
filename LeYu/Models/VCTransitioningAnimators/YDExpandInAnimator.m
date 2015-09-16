//
//  YDExpandInAnimator.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/8/4.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "YDExpandInAnimator.h"

@implementation YDExpandInAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = toVC.view;
    
    if (CGRectIsEmpty(self.startRect)) {
        self.startRect = toView.bounds;
    }
    
    CGFloat scaleX = self.startRect.size.width / toView.maskView.frame.size.width;
    CGFloat scaleY = self.startRect.size.height / toView.maskView.frame.size.height;
    
    CGFloat translationX = (self.startRect.size.width / 2 + self.startRect.origin.x) - toView.maskView.center.x;
    CGFloat translationY = (self.startRect.size.height / 2 + self.startRect.origin.y) - toView.maskView.center.y;
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];

    CGAffineTransform t1 = CGAffineTransformMakeScale(scaleX, scaleY);
    CGAffineTransform t2 = CGAffineTransformMakeTranslation(translationX, translationY);
    toView.maskView.transform = CGAffineTransformConcat(t1, t2);
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         toView.maskView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}

@end
