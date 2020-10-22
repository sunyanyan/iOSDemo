//
//  NSObject+Swizzle.m
//  KM
//
//  Created by cbs on 2019/9/4.
//  Copyright © 2019 popo.netease.com. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>


@implementation NSObject (Swizzle)

+ (BOOL)swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel class:(Class)cls {
    
    Method originMethod = class_getInstanceMethod(cls, oriSel);
    Method swizzledMethod = class_getInstanceMethod(cls, swiSel);
    if (!swizzledMethod || !originMethod) {
        return NO;
    }
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originMethod swizzledSel:swiSel swizzledMethod:swizzledMethod class:cls];
    
    return YES;
}

+ (BOOL)swizzleClassMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel class:(Class)cls {
    
    Method originMethod = class_getClassMethod(cls, oriSel);
    Method swizzledMethod = class_getClassMethod(cls, swiSel);
    if (!swizzledMethod || !originMethod) {
        return NO;
    }
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originMethod swizzledSel:swiSel swizzledMethod:swizzledMethod class:cls];
    
    return YES;
}

+ (void)swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                             class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}



@end
