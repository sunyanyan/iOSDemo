//
//  NSURL+Util.h
//  iOSDemo
//
//  Created by 孙同生 on 2020/7/1.
//  Copyright © 2020 孙同生. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (Util)



/**
 文件名
 */
+(NSString*)nameFromUrl:(NSURL*)nsurl;

/**
 文件后缀名
 */
+(NSString*)typeFromUrl:(NSURL*)nsurl;

/**
 文件大小
 */
+(float)fileSizeFromUrl:(NSURL*)nsurl;

@end

NS_ASSUME_NONNULL_END
