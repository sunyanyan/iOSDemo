//
//  TSURLProtocol.h
//  iOSDemo
//
//  Created by 孙同生 on 2020/10/20.
//  Copyright © 2020 孙同生. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TSURLProtocol;
@protocol TSURLProtocolDelegate <NSObject>

/**
 获取流量请求监控

 @param URLProtocol 连接协议对象
 */
- (void)URLProtocolDidCatchURLRequest:(TSURLProtocol *)URLProtocol;

@end

@interface TSURLProtocol : NSURLProtocol


/**
 URLConnection 连接对象
 */
@property (nonatomic, strong, readonly) NSURLConnection *fs_connection;

/**
 NSURLRequest 请求对象
 */
@property (nonatomic, strong, readonly) NSURLRequest *fs_request;

/**
 NSURLResponse 返回对象
 */
@property (nonatomic, strong, readonly) NSURLResponse *fs_response;

/**
 NSMutableData 接收对象
 */
@property (nonatomic, strong, readonly) NSMutableData *fs_receive_data;

/**
 请求开始时间
 */
@property (nonatomic, strong, readonly) NSDate *startDate;

/**
 请求结束时间
 */
@property (nonatomic, strong, readonly) NSDate *endDate;

/**
 是否 Hook NSURLSessionConfiguration 对象
 原因：由于NSURLSessionConfiguration 有 protocolClasses 属性，不走自定义 NSURLProtocol
 需 hook 方法将 FSURLProtocol 放入首位
 
 @param hook BOOL
 */
+ (void)setHookNSURLSessionConfiguration:(BOOL)hook;

/**
 开启委托监控

 @param delegate 委托对象
 */
+ (void)addDelegate:(id<TSURLProtocolDelegate>)delegate;

/**
 去除委托监控

 @param delegate 委托对象
 */
+ (void)removeDelegate:(id<TSURLProtocolDelegate>)delegate;


@end

NS_ASSUME_NONNULL_END
