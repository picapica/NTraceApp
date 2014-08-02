//
//  NetInterface.m
//  NetConnectPro
//
//  Created by Liu Lantao on 13-4-15.
//  Copyright (c) 2013年 Liu Lantao. All rights reserved.
//

#import "NetInterface.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation NetInterface

+ (NSString *)getIPAddress {
    return [NetInterface localAddressForInterface:@"en0"];
}

+ (NSMutableDictionary *) getInterfaceList
{
    NSMutableArray *arrayOfAllInterfaces = [NSMutableArray array];
    NSMutableDictionary *dictOfAllInterfaces = [NSMutableDictionary dictionary];

    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                NSString* name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString* address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                
                [arrayOfAllInterfaces addObject:name];
                [dictOfAllInterfaces setObject:address forKey:name];
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    // return arrayOfAllInterfaces;
    return dictOfAllInterfaces;
}

+ (NSString *) localAddressForInterface:(NSString *)interface
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                NSLog(@"if; %@ %@", [NSString stringWithUTF8String:temp_addr->ifa_name],
                      [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:interface]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    break;
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

@end
