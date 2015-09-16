//
//  YDShrinkOutAnimator.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/8/4.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "YDShrinkOutAnimator.h"

@implementation YDShrinkOutAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *fromView = fromVC.view;
    
    if (CGRectIsEmpty(self.endRect)) {
        self.endRect = (CGRect){fromView.center, CGSizeZero};
    }
    
    CGFloat scaleX = self.endRect.size.width / fromView.maskView.frame.size.width;
    CGFloat scaleY = self.endRect.size.height / fromView.maskView.frame.size.height;
    CGFloat translationX = (self.endRect.size.width / 2 + self.endRect.origin.x) - fromView.maskView.center.x;
    CGFloat translationY = (self.endRect.size.height / 2 + self.endRect.origin.y) - fromView.maskView.center.y;
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewKeyframeAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGAffineTransform t1 = CGAffineTransformMakeScale(scaleX, scaleY);
                         CGAffineTransform t2 = CGAffineTransformMakeTranslation(translationX, translationY);
                         fromView.maskView.transform = CGAffineTransformConcat(t1, t2);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2 animations:^{
                             fromView.alpha = 0;
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         }];
                     }];
}

@end
