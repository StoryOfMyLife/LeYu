//
//  StringFactory.m
//  LifeO2O
//
//  Created by jiecongwang on 5/30/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "StringFactory.h"

@implementation StringFactory

+(BOOL) isEmptyString:(NSString *)string {
    if (string ==nil) return YES;
    
    NSString *trimString =[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([trimString length]==0) return YES;
    
    return NO;
};



+ (NSString*)defaultFontType {
    return @"Helvetica";
}

@end
