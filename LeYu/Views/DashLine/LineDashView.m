//
//  LineDashView.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/6/22.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "LineDashView.h"

@interface LineDashView ()
{
    CAShapeLayer  *_shapeLayer;
}

@end

@implementation LineDashView

@synthesize endOffset = _endOffset;
@synthesize lineDashPattern = _lineDashPattern;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _shapeLayer             = (CAShapeLayer *)self.layer;
        _shapeLayer.fillColor   = [UIColor clearColor].CGColor;
        _shapeLayer.strokeStart = 0.001;
        _shapeLayer.strokeEnd   = 0.499;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
              lineDashPattern:(NSArray *)lineDashPattern
                    endOffset:(CGFloat)endOffset
{
    LineDashView *lineDashView   = [[LineDashView alloc] initWithFrame:frame];
    lineDashView.lineDashPattern = lineDashPattern;
    lineDashView.endOffset       = endOffset;
    
    return lineDashView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIBezierPath *path      = [UIBezierPath bezierPathWithRect:self.bounds];
    _shapeLayer.lineWidth   = self.height;
    _shapeLayer.path        = path.CGPath;
    
}

#pragma mark - 修改view的backedLayer为CAShapeLayer

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

#pragma mark - 改写属性的getter,setter方法

- (void)setLineDashPattern:(NSArray *)lineDashPattern
{
    _lineDashPattern            = lineDashPattern;
    _shapeLayer.lineDashPattern = lineDashPattern;
}

- (NSArray *)lineDashPattern
{
    return _lineDashPattern;
}

- (void)setEndOffset:(CGFloat)endOffset
{
    _endOffset = endOffset;
    if (endOffset < 0.499 && endOffset > 0.001)
    {
        _shapeLayer.strokeEnd = _endOffset;
    }
}

- (CGFloat)endOffset
{
    return _endOffset;
}

#pragma mark - 

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _shapeLayer.strokeColor = backgroundColor.CGColor;
}

- (UIColor *)backgroundColor
{
    return [UIColor colorWithCGColor:_shapeLayer.strokeColor];
}

@end
