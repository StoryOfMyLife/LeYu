//
//  NSDate+Compare.m
//  YoudaoDict
//
//  Created by 刘廷勇 on 15/4/10.
//  Copyright (c) 2015年 Netease Youdao. All rights reserved.
//

#import "NSDate+Compare.h"

@implementation NSDate (Compare)

+ (BOOL)isDate:(NSDate *)date laterThan:(NSDate *)comparedDate;
{
    if ([date compare:comparedDate] == NSOrderedDescending) {
        NSLog(@"date1 is later than date2");
        return YES;
    } else if ([date compare:comparedDate] == NSOrderedAscending) {
        return NO;
    } else {
        return NO;
    }
}

- (BOOL)isSameDay:(NSDate *)oneDay
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    
    NSString *day1 = [formatter stringFromDate:oneDay];
    NSString *day2 = [formatter stringFromDate:self];
    
    return [day1 isEqualToString:day2];
}

@end
