//
//  NSURLSessionConfiguration+TSNet.h
//  iOSDemo
//
//  Created by 孙同生 on 2020/10/22.
//  Copyright © 2020 孙同生. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSessionConfiguration (TSNet)
/**
 开启 hook
 */
+ (void)start;

/**
 关闭 hook
 */
+ (void)stop;

@end

NS_ASSUME_NONNULL_END
