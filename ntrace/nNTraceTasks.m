//
//  nNTraceTasks.m
//  NTrace
//
//  Created by Liu Lantao on 13-5-3.
//  Copyright (c) 2013年 Liu Lantao. All rights reserved.
//

#import "nNTraceTasks.h"

@implementation nNTraceTasks

+ (NSDictionary *)tasks {
    return [nNTraceTasks fetchTasks];
}

+ (NSDictionary *)fetchTasks {
    NSError *error;
    NSString *url_string = [NSString stringWithFormat:@"http://10.4.16.68/ntrace/api/task/%d", 1];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url_string]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    NSDictionary *tasks = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];

    return tasks;
}

+ (NSMutableDictionary *)executeTasks {
    NSDictionary *tasks = [nNTraceTasks tasks];
    NSMutableDictionary *results = [NSMutableDictionary dictionary];

    for (NSString *name in tasks) {
        // NSLog(@"execute: %@ => %@", name, [tasks valueForKey:name]);
        
        NSDictionary *r = [nNTraceTasks execute:[tasks objectForKey:name]];

        [results setObject:r forKey:name];
    }
    
    return results;
}

+ (NSMutableDictionary *)execute:(NSDictionary *)task {
    
    // NSLog(@"execute task: %@", task);

    NSDictionary *type_list = [NSDictionary dictionaryWithObjectsAndKeys:
                               @TASK_PING, @"ping",
                               @TASK_FETCH, @"fetch",
                               nil];

    NSMutableDictionary *result;
    
    NSString *type_string = [task objectForKey:@"type"];
    NSNumber *type = [type_list objectForKey:type_string];
    
    // NSLog(@"%@ %@ %d", type_string, type, [type intValue]);
    
    switch ([type intValue]) {
        case TASK_PING:
            // ping
            result = [nNTraceTasks ping:[task objectForKey:@"host"]];
            break;

        case TASK_FETCH:
            // fetch
            result = [nNTraceTasks fetch:[task objectForKey:@"file"]];
            break;

        default:
            [result setObject:@"unknown_task_type" forKey:@"status"];
            break;
    }
    
    return result;
}

+ (NSMutableDictionary *)ping:(NSString *)host {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    SCNetworkConnectionFlags flags = 0;
    if (SCNetworkReachabilityGetFlags(SCNetworkReachabilityCreateWithName(NULL, [host cStringUsingEncoding:NSUTF8StringEncoding]), &flags) && flags > 0) {
        // NSLog(@"Host is reachable: %d", flags);
        [result setObject:@"yes" forKey:@"reachable"];
    }
    else {        
        [result setObject:@"no" forKey:@"reachable"];
    }
    [result setObject:[NSString stringWithFormat:@"ping %@", host] forKey:@"description"];
    
    return result;
}

+ (NSMutableDictionary *)fetch:(NSString *)file {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:[NSString stringWithFormat:@"fetch %@", file] forKey:@"description"];

    return result;
}

@end
