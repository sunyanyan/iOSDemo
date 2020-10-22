//
//  PreviewUrlView.h
//  iOSDemo
//
//  Created by 孙同生 on 2020/7/10.
//  Copyright © 2020 孙同生. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PreviewUrlView : NSObject
@property(nonatomic)WKWebView* webview;
-(void)loadUrl:(NSURL*)url;
@end

NS_ASSUME_NONNULL_END
