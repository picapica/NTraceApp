//
//  SettingStore.m
//  NTrace
//
//  Created by Liu Lantao on 13-5-3.
//  Copyright (c) 2013年 Liu Lantao. All rights reserved.
//

#import "SettingStore.h"


@implementation SettingStore

@synthesize apiServerTxt;
@synthesize taskIDTxt;
@synthesize userIdentityTxt;

@synthesize userSettingStore;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+ (SettingStore*)Values
{
    static SettingStore *vals;
    @synchronized(self)
    {
        if (!vals)
            vals = [[SettingStore alloc] init];
        return vals;
    }
}


+ (void)saveValues {
    NSUserDefaults *userSettingStore = [NSUserDefaults standardUserDefaults];

    [userSettingStore setObject:[SettingStore Values].apiServerTxt forKey:@"nSettingStore_apiServer"];
    [userSettingStore setObject:[SettingStore Values].taskIDTxt forKey:@"nSettingStore_taskID"];
    [userSettingStore setObject:[SettingStore Values].userIdentityTxt forKey:@"nSettingStore_userIdentity"];

    [SettingStore showValues];
}

+ (void)loadValues {
    NSUserDefaults *userSettingStore = [NSUserDefaults standardUserDefaults];

    [SettingStore Values].apiServerTxt = [userSettingStore objectForKey:@"nSettingStore_apiServer"] ? [userSettingStore objectForKey:@"nSettingStore_apiServer"] : @"http://118.186.217.100/ntrace/api";
    [SettingStore Values].taskIDTxt = [userSettingStore objectForKey:@"nSettingStore_taskID"] ? [userSettingStore objectForKey:@"nSettingStore_taskID"] : @"1";
    [SettingStore Values].userIdentityTxt = [userSettingStore objectForKey:@"nSettingStore_userIdentity"] ? [userSettingStore objectForKey:@"nSettingStore_userIdentity"] : @"uid_0";

    [SettingStore showValues];
}

+ (void) showValues {
    // NSLog(@"SettingStore : apiServer : %@ ; taskID : %@ ; userIdentity : %@ ", [SettingStore Values].apiServerTxt, [SettingStore Values].taskIDTxt, [SettingStore Values].userIdentityTxt);
}

+ (void)restoreDefaults
{
    [SettingStore Values].apiServerTxt = @"http://118.186.217.100/ntrace/api";
    [SettingStore Values].taskIDTxt = @"1";
    [SettingStore Values].userIdentityTxt = @"uid_0";

    [SettingStore saveValues];
}

@end
