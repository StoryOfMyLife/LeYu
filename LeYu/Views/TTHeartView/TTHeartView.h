//
//  ZDHeartView.h
//  Zhidao
//
//  Created by Nick Yu on 8/13/14.
//  Copyright (c) 2014 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TTHeartAnimationBlock)();

@interface TTHeartView : UIView
@property(nonatomic, strong) UIImageView * imageViewTop;
@property(nonatomic, strong) UIImageView * imageViewBase;
@property(nonatomic, strong) CAShapeLayer *shapelayer;
@property(nonatomic, assign) BOOL hasLiked;

-(void)doAnimationWithAppendAnimation:(TTHeartAnimationBlock)animation completion:(TTHeartAnimationBlock)completion;

@end
