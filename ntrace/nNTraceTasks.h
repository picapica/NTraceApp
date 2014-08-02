//
//  nNTraceTasks.h
//  NTrace
//
//  Created by Liu Lantao on 13-5-3.
//  Copyright (c) 2013年 Liu Lantao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

#define TASK_PING  1
#define TASK_FETCH 2
#define TASK_DNSQUERY 3

@interface nNTraceTasks : NSObject

+ (NSDictionary *)tasks;

+ (NSDictionary *)fetchTasks;
+ (NSMutableDictionary *)executeTasks;
+ (void)postResults:(NSData *)data;

+ (NSMutableDictionary *)ping:(NSString *)ip;
+ (NSMutableDictionary *)fetch:(NSString *)url;
+ (NSMutableDictionary *)dnsQuery:(NSString* )domainName;
@end
