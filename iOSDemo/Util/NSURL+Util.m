//
//  NSURL+Util.m
//  iOSDemo
//
//  Created by 孙同生 on 2020/7/1.
//  Copyright © 2020 孙同生. All rights reserved.
//

#import "NSURL+Util.h"

@implementation NSURL (Util)



/**
 文件名
 */
+(NSString*)nameFromUrl:(NSURL*)nsurl{
    NSString* lastC = [[nsurl.absoluteString componentsSeparatedByString:@"/"] lastObject];
    if(!(lastC && lastC.length > 0)) return nil;
    NSString* name = [[lastC componentsSeparatedByString:@"."] firstObject];
    return name;
}

/**
 文件后缀名
 */
+(NSString*)typeFromUrl:(NSURL*)nsurl{
    NSString* lastC = [[nsurl.absoluteString componentsSeparatedByString:@"/"] lastObject];
    if(!(lastC && lastC.length > 0)) return nil;
    NSString* type = [[lastC componentsSeparatedByString:@"."] lastObject];
    return type;
}

/**
 文件大小
 */
+(float)fileSizeFromUrl:(NSURL*)nsurl{
     NSDictionary* info = [[NSFileManager defaultManager] attributesOfItemAtPath:[nsurl path] error:nil];
    if(!info) return 0;
    return [info[NSFileSize] floatValue];
}

@end
