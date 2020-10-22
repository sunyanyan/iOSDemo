//
//  UIColor+Util.m
//  iOSDemo
//
//  Created by 孙同生 on 2020/7/1.
//  Copyright © 2020 孙同生. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)


/**
 从十六进制中转换颜色
 
 @param " hexString :  "#00FF00" (#RRGGBB).
 */
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
