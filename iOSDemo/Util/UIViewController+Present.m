//
//  UIViewController+Present.m
//  KM
//
//  Created by cbs on 2019/9/4.
//  Copyright © 2019 popo.netease.com. All rights reserved.
//

#import "UIViewController+Present.h"
#import "NSObject+Swizzle.h"
@implementation UIViewController (Present)

+ (void)load
{
    [super load];
    
    SEL oldSel = @selector(presentViewController:animated:completion:);
    SEL newSel = @selector(popo_presentViewController:animated:completion:);
    [self swizzleInstanceMethodWithOriginSel:oldSel swizzledSel:newSel class:self];
}

- (void)popo_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if (@available(iOS 13.0, *)) {
        if (viewControllerToPresent.modalPresentationStyle == UIModalPresentationAutomatic ||
            viewControllerToPresent.modalPresentationStyle == UIModalPresentationPageSheet) {
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        }
    }
    if(self != viewControllerToPresent){
        [self popo_presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
    
}

@end
