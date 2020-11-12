//
//  TSURLMonitor.h
//  iOSDemo
//
//  Created by 孙同生 on 2020/10/30.
//  Copyright © 2020 孙同生. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSURLNetInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TSURLMonitor;
@protocol TSURLMonitorDelegate <NSObject>

/**
 网络监控回调

 @param monitor 监控对象
 @param networkInfo 流量数据
 */
- (void)networkMonitor:(TSURLMonitor *)monitor didCatchNetworkInfo:(TSURLNetInfoModel *)networkInfo;

@end

@interface TSURLMonitor : NSObject

/**
 是否启动
 */
@property (nonatomic, assign, readonly) BOOL isRunning;

/**
 单例对象
 
 @return FSNetworkMonitor
 */
+ (TSURLMonitor *)sharedInstance;

/**
 委托对象添加网络
 
 @param delegate 委托对象
 */
- (void)addDelegate:(id<TSURLMonitorDelegate>)delegate;

/**
 委托对象去掉网络
 
 @param delegate 委托对象
 */
- (void)removeDelegate:(id<TSURLMonitorDelegate>)delegate;

/**
 开启监控网络
 */
- (void)start;

/**
 关闭监控网络
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
