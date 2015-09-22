//
//  NSDate+Compare.h
//  YoudaoDict
//
//  Created by 刘廷勇 on 15/4/10.
//  Copyright (c) 2015年 Netease Youdao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Compare)

+ (BOOL)isDate:(NSDate *)date laterThan:(NSDate *)comparedDate;
- (BOOL)isSameDay:(NSDate *)oneDay;

@end
