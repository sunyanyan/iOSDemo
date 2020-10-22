//
//  UIColor+Util.h
//  iOSDemo
//
//  Created by 孙同生 on 2020/7/1.
//  Copyright © 2020 孙同生. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Util)

/**
 从十六进制中转换颜色
 
 @param hexString  :  "#00FF00" (#RRGGBB).
 */
+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end

NS_ASSUME_NONNULL_END
