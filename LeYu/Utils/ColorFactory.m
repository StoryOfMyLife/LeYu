//
//  ColorFactory.m
//  LifeO2O
//
//  Created by jiecongwang on 5/28/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "ColorFactory.h"



@implementation ColorFactory

+(UIColor *)navigationBarTitleColor{
    return UIColorFromRGB(0x818180);
}

+(UIColor *)navigationBarBackgroundColor{
    return DefaultDarkBackgroundColor;//UIColorFromRGB(0x262420);

}

+(UIColor *)tabBarItemTitleSelectedColor {
    return UIColorFromRGB(0x212c47);
}

+(UIColor *)tabBarItemTitleNormalColor {
    return UIColorFromRGB(0x9c9c9c);
}

+(UIColor *)dyLightGray{
    return DefaultBackgroundColor;
}



@end
