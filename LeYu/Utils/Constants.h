//
//  Constants.h
//  LifeO2O
//
//  Created by jiecongwang on 5/30/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#ifndef LifeO2O_Constants_h
#define LifeO2O_Constants_h

#define WeakObject(object) typeof(object) __weak
#define WeakSelf WeakObject(self)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define DefaultYellowColor RGBCOLOR(193, 153, 61)
#define DefaultBackgroundColor UIColorFromRGB(0xF0F0F0)

#endif
