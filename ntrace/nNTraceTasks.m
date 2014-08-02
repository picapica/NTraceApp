//
//  nNTraceTasks.m
//  NTrace
//
//  Created by Liu Lantao on 13-5-3.
//  Copyright (c) 2013年 Liu Lantao. All rights reserved.
//

#import "nNTraceTasks.h"
#import "NetInterface.h"
#import "SettingStore.h"
#import <time.h>

#include <CFHost.h>

#include <netdb.h>
#include <arpa/inet.h>

//#include <arpa/inet.h>
//#include <ifaddrs.h>
//#include <resolv.h>
//#include <dns.h>

@implementation nNTraceTasks

+ (NSDictionary *)tasks
{
    return [nNTraceTasks fetchTasks];
}

+ (NSDictionary *)fetchTasks
{
    NSError *error;
    NSString *url_string = [NSString stringWithFormat:@"%@/task/%@?_uid=%@", [SettingStore Values].apiServerTxt, [SettingStore Values].taskIDTxt, [SettingStore Values].userIdentityTxt];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url_string]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    NSDictionary *tasks = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];

    return tasks;
}

+ (NSMutableDictionary *)executeTasks
{
    NSDictionary *tasks = [nNTraceTasks tasks];
    NSMutableDictionary *results = [NSMutableDictionary dictionary];

    for (NSString *name in tasks) {
        // NSLog(@"execute: %@ => %@", name, [tasks valueForKey:name]);
        
        NSDictionary *r = [nNTraceTasks execute:[tasks objectForKey:name]];

        [results setObject:r forKey:name];
    }
    
    return results;
}

+ (void)postResults:(NSData *)data
{
    NSError *error;
    NSString *url_string = [NSString stringWithFormat:@"%@/task/%@/post?_uid=%@",  [SettingStore Values].apiServerTxt, [SettingStore Values].taskIDTxt, [SettingStore Values].userIdentityTxt];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url_string] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];

    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    NSLog(@"post response : %@ ; error : %@", response, error);
}


+ (NSMutableDictionary *)execute:(NSDictionary *)task
{
    
    // NSLog(@"execute task: %@", task);

    NSDictionary *type_list = [NSDictionary dictionaryWithObjectsAndKeys:
                               @TASK_PING, @"ping",
                               @TASK_FETCH, @"fetch",
                               @TASK_DNSQUERY, @"dnsquery",
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
            
        case TASK_DNSQUERY:
            // dns
//            [result setObject:@"dnsquery_received" forKey:@"status"];
            result = [nNTraceTasks dnsQuery:[task objectForKey:@"host"]];
            break;

        default:
            [result setObject:@"unknown_task_type" forKey:@"status"];
            break;
    }

    return result;
}

+ (NSMutableDictionary *)ping:(NSString *)host
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    SCNetworkConnectionFlags flags = 0;
    if (SCNetworkReachabilityGetFlags(SCNetworkReachabilityCreateWithName(NULL, [host cStringUsingEncoding:NSUTF8StringEncoding]), &flags) && flags > 0) {
        // NSLog(@"Host %@ is reachable: %d", host, flags);
        [result setObject:@"yes" forKey:@"reachable"];
    }
    else {        
        [result setObject:@"no" forKey:@"reachable"];
    }
    [result setObject:[NSString stringWithFormat:@"ping %@", host] forKey:@"description"];

    return result;
}

+ (NSMutableDictionary *)fetch:(NSString *)file
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    NSMutableURLRequest *testRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:file] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];

    NSURLResponse *testResponse;
    NSError *testError;


    NSDate *date = [NSDate date];
    NSData *testData = [NSURLConnection sendSynchronousRequest:testRequest returningResponse:&testResponse error:&testError];
    double timePassed_seconds = [date timeIntervalSinceNow] * -1.0;
    [result setValue:[NSString stringWithFormat:@"%.3fs", timePassed_seconds] forKey:@"time"];

    NSHTTPURLResponse *response = (NSHTTPURLResponse *)testResponse;
    int statusCode = [response statusCode];
    [result setValue:[NSString stringWithFormat:@"%d", statusCode] forKey:@"status"];

    int errorCode = testError.code;
    [result setValue:[NSString stringWithFormat:@"%d", errorCode] forKey:@"code"];

    NSString *responseStr = [[NSString alloc] initWithData:testData encoding:NSASCIIStringEncoding];
    int length = [responseStr length];
    [result setValue:[NSString stringWithFormat:@"%d", length] forKey:@"body_length"];

    [result setObject:[NSString stringWithFormat:@"fetch %@", file] forKey:@"description"];

    return result;
}

//+ (NSString *) getDNSServers
//{
//    NSMutableString *addresses = [[NSMutableString alloc]initWithString:@"DNS Addresses \n"];
//    
//    res_state res = malloc(sizeof(struct __res_state));
//    
//    int result = res_ninit(res);
//    
//    if ( result == 0 )
//    {
//        for ( int i = 0; i < res->nscount; i++ )
//        {
//            NSString *s = [NSString stringWithUTF8String :  inet_ntoa(res->nsaddr_list[i].sin_addr)];
//            [addresses appendFormat:@"%@\n",s];
//            NSLog(@"%@",s);
//        }
//    }
//    else
//    {
//        [addresses appendString:@" res_init result != 0"];
//    }
//    
//    return addresses;
//}

+ (void)testDNS
{
    NSLog(@"testDNS");
    NSString *hostname = @"www.renren.com";

    SCNetworkConnectionFlags flags = 0;
    if (SCNetworkReachabilityGetFlags(SCNetworkReachabilityCreateWithName(NULL, [hostname cStringUsingEncoding:NSUTF8StringEncoding]), &flags) && flags > 0) {
        // NSLog(@"Host %@ is reachable: %d", hostname, flags);

        Boolean result;
        CFHostRef hostRef;
        NSArray *addresses;
        
        hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)hostname);
//        if (hostRef) {
//            result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL); // pass an error instead of NULL here to find out why it failed
//            if (result == TRUE) {
//                addresses = (__bridge NSArray*)CFHostGetAddressing(hostRef, &result);
//                [addresses enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    NSString *strDNS = [NSString stringWithUTF8String:inet_ntoa(*((__bridge struct in_addr *)obj))];
//                    NSLog(@"Resolved %d->%@", idx, strDNS);
//                }];
//            }
//        }

    }
    else {
    }
}

+ (NSMutableDictionary *)dnsQuery:(NSString* )domainName
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    [nNTraceTasks testDNS];

	// Get host entry info for given host
	struct hostent *remoteHostEnt = gethostbyname([domainName cStringUsingEncoding:NSUTF8StringEncoding]);

//    struct in_addr *tempInAddr;
//    char *tempAddr;
//    for (int i = 0; remoteHostEnt->h_addr_list[i]; i++)
//    {
//        tempInAddr = (struct in_addr *) remoteHostEnt->h_addr_list[i];
//        tempAddr = inet_ntoa(*tempInAddr);
//        NSLog(@"%d %s", i, tempAddr);
//    }

	// Get address info from host entry
	struct in_addr *remoteInAddr = (struct in_addr *) remoteHostEnt->h_addr_list[0];
	// Convert numeric addr to ASCII string
	char *sRemoteInAddr = inet_ntoa(*remoteInAddr);

	NSString *s = [[NSString alloc]
                   initWithFormat:
                   @"Remote IP: %s",
                   sRemoteInAddr];
    
    [result setObject:s forKey:@"result"];

    [result setObject:[NSString stringWithFormat:@"DNS query %@", domainName] forKey:@"description"];
    
    return result;
}

@end
