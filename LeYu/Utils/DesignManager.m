//
//  DesignManager.m
//  LifeO2O
//
//  Created by jiecongwang on 5/28/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "DesignManager.h"
#import "ColorFactory.h"
#import "ImageFactory.h"

@implementation DesignManager

+(void)applyDesign {

    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [ColorFactory navigationBarTitleColor], NSForegroundColorAttributeName,
                                                          [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],UITextAttributeTextShadowOffset,
                                                          [UIFont fontWithName:@"Helvetica" size:22.0f], NSFontAttributeName,
                                                          nil]];
    
    [[UINavigationBar appearance] setBarTintColor:[ColorFactory navigationBarBackgroundColor]];
   // [[UINavigationBar appearance] setBackgroundImage:[ImageFactory navigationBarBackground] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBarTintColor:DefaultBackgroundColor];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorFactory tabBarItemTitleNormalColor],NSForegroundColorAttributeName,[NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],UITextAttributeTextShadowOffset, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[ColorFactory tabBarItemTitleSelectedColor],NSForegroundColorAttributeName,[NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],UITextAttributeTextShadowOffset, nil] forState:UIControlStateSelected];
    
    [[UITabBar appearance] setTranslucent:NO];
}

@end
