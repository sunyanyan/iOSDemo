//
//  PreviewUrlView.m
//  iOSDemo
//
//  Created by 孙同生 on 2020/7/10.
//  Copyright © 2020 孙同生. All rights reserved.
//

#import "PreviewUrlView.h"


@interface PreviewUrlView()<WKNavigationDelegate>



@end


@implementation PreviewUrlView

-(void)loadUrl:(NSURL*)url{
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
}



-(WKWebView *)webview{
    if(!_webview){
        WKWebView* webview = [[WKWebView alloc] init];
        webview.navigationDelegate = self;
        _webview = webview;
    }
    return _webview;
}

//MARK: -

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@" didFailNavigation ");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@" didFinishNavigation ");
    [webView evaluateJavaScript:@"document.title"
                completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
        NSString *title = ret;
       NSLog(@" didFinishNavigation title %@",title);
    }];
       
    
}
@end
