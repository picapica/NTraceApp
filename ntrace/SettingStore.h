//
//  SettingStore.h
//  NTrace
//
//  Created by Liu Lantao on 13-5-3.
//  Copyright (c) 2013年 Liu Lantao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SettingStore: NSManagedObject {
    NSString *apiServerTxt;
    NSString *taskIDTxt;
    NSString *userIdentityTxt;
}

@property (nonatomic, retain) NSDictionary * userSettingStore;

@property (nonatomic, retain) NSString * apiServerTxt;
@property (nonatomic, retain) NSString * taskIDTxt;
@property (nonatomic, retain) NSString * userIdentityTxt;

+ (SettingStore*)Values;
+ (void) saveValues;
+ (void) loadValues;

+ (void) showValues;

+ (void) restoreDefaults;

@end
