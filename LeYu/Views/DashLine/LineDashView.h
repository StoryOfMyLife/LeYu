//
//  LineDashView.h
//  LifeO2O
//
//  Created by 刘廷勇 on 15/6/22.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineDashView : UIView

@property (nonatomic, strong) NSArray *lineDashPattern;  // 线段分割模式
@property (nonatomic, assign) CGFloat endOffset;        // 取值在 0.001 --> 0.499 之间

- (instancetype)initWithFrame:(CGRect)frame
              lineDashPattern:(NSArray *)lineDashPattern
                    endOffset:(CGFloat)endOffset;

@end
