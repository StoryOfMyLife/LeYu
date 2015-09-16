//
//  UIButton+Center.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/7/12.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "UIButton+Center.h"

@implementation UIButton (Center)

- (void)centerImage
{
    // the space between the image and text
    CGFloat spacing = 10.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = self.imageView.image.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0,
                                            - imageSize.width,
                                            - (imageSize.height + spacing),
                                            0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing),
                                            0.0,
                                            0.0,
                                            - titleSize.width);
}

@end
