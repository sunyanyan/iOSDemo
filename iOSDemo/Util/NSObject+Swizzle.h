//
//  NSObject+Swizzle.h
//  KM
//
//  Created by cbs on 2019/9/4.
//  Copyright © 2019 popo.netease.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzle)

+ (BOOL)swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel class:(Class)cls;

+ (BOOL)swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel class:(Class)cls;

@end

NS_ASSUME_NONNULL_END
