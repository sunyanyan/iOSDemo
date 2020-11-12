//
//  TSURLMonitor.m
//  iOSDemo
//
//  Created by 孙同生 on 2020/10/30.
//  Copyright © 2020 孙同生. All rights reserved.
//

#import "TSURLMonitor.h"
#import "TSURLProtocol.h"

@interface TSURLMonitor()

/**
 委托回调对象集合
 */
@property (nonatomic, strong) NSHashTable *hashTable;

/**
 是否启动
 */
@property (nonatomic, assign, readwrite) BOOL isRunning;

@end

@implementation TSURLMonitor

#pragma mark - Life Cycle
/**
 单例对象
 
 @return TSURLMonitor
 */
+ (TSURLMonitor *)sharedInstance  {
    static TSURLMonitor *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 初始化

 @return TSURLMonitor
 */
- (instancetype)init {
    if (self = [super init]) {
        _isRunning = NO;
    }
    return self;
}

/**
 释放
 */
- (void)dealloc {
    [self stop];
    [self p_removeAllDelegates];
}

#pragma mark - Public Method
/**
 开启网络监控
 
 @param delegate 委托对象
 */
- (void)addDelegate:(id<TSURLMonitorDelegate>)delegate {
    [self.hashTable addObject:delegate];
}

/**
 关闭网络监控
 
 @param delegate 委托对象
 */
- (void)removeDelegate:(id<TSURLMonitorDelegate>)delegate {
    if ([self.hashTable containsObject:delegate]) {
        [self.hashTable removeObject:delegate];
    }
}

/**
 开启网络监控
 */
- (void)start {
    if (_isRunning) {
        return;
    }
    _isRunning = YES;
    [TSURLProtocol addDelegate:self];
}

/**
 关闭网络监控
 */
- (void)stop {
    if (!_isRunning) {
        return;
    }
    _isRunning = NO;
    [TSURLProtocol removeDelegate:self];
}

#pragma mark - Private Method
/**
 关闭所有委托对象
 */
- (void)p_removeAllDelegates {
    [self.hashTable removeAllObjects];
}

#pragma mark -FSURLProtocolDelegate
/**
 获取流量请求监控
 
 @param URLProtocol 连接协议对象
 */
- (void)URLProtocolDidCatchURLRequest:(TSURLProtocol *)URLProtocol {
    if (!_hashTable) {
        return;
    }
    
//    NSDate* startDate = URLProtocol.startDate;
//    NSDate* endDate = URLProtocol.endDate;
//    NSInteger time = URLProtocol.startDate.timeIntervalSince1970;
//    NSInteger during = [URLProtocol.endDate timeIntervalSinceDate:URLProtocol.startDate];
//    NSURLRequest* request = URLProtocol.fs_request;
//    NSURLResponse *response = (NSHTTPURLResponse *)URLProtocol.fs_response;
//    NSDate* data = [URLProtocol.fs_receive_data copy];
    
    NSLog(@" %s URLProtocol %@",__func__,URLProtocol);
}

#pragma mark - Getters and Setters
/**
 卡顿委托回调对象集合
 
 @return NSHashTable
 */
- (NSHashTable *)hashTable {
    if (!_hashTable) {
        _hashTable = [NSHashTable weakObjectsHashTable];
    }
    return _hashTable;
}

@end
