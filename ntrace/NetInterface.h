//
//  NetInterface.h
//  NetConnectPro
//
//  Created by Liu Lantao on 13-4-15.
//  Copyright (c) 2013年 Liu Lantao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetInterface : NSObject

+ (NSMutableDictionary *) getInterfaceList;
+ (NSString *) localAddressForInterface:(NSString *)interface;
+ (NSString *) getIPAddress;

@end