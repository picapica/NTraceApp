//
//  nViewController.m
//  ntrace
//
//  Created by Liu Lantao on 13-5-2.
//  Copyright (c) 2013年 Liu Lantao. All rights reserved.
//

#import "nViewController.h"
#import "NetInterface.h"
#import "nNTraceTasks.h"

@interface nViewController ()

@end

@implementation nViewController

@synthesize logTextArea;

- (void)appendLog:(NSString *)logmessage to:(UITextView *)area {
    NSString *logcache = area.text;
    
    area.text = [NSString stringWithFormat:@"%@ %@\n", logcache, logmessage];
    [area scrollRangeToVisible:NSMakeRange(logcache.length + logmessage.length, 0)];
}

- (NSString *)timestamp {
    NSDateFormatter *formatter;
    NSString        *dateString;

    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];

    dateString = [formatter stringFromDate:[NSDate date]];

    return dateString;
}

- (void)appendLog:(NSString *)logmessage to:(UITextView *)area timestamp:(BOOL)timestamp_enabled {
    if (timestamp_enabled) {
        logmessage = [NSString stringWithFormat:@"[%@] %@", [self timestamp], logmessage];
        [self appendLog:logmessage to:area];
    }
    else
    {
        [self appendLog:logmessage to:area];
    }
}

- (void)printInterfaceList{
    NSMutableDictionary* allInterfaceList = [NetInterface getInterfaceList];
    for (NSString *name in allInterfaceList)
    {
        [self appendLog:[NSString stringWithFormat:@"Interface %@ : %@", name, [allInterfaceList objectForKey:name]] to:logTextArea];
    }
}

- (IBAction)btnExecCheckClicked:(id)sender {
    NSMutableDictionary *result = [nNTraceTasks executeTasks];
    NSMutableDictionary *interfaces = [NSMutableDictionary dictionary];

    NSDictionary* allInterfaceList = [NetInterface getInterfaceList];
    for (NSString *name in allInterfaceList)
    {
        [interfaces setObject:[allInterfaceList objectForKey:name] forKey:name];
    }
    
    [result setObject:interfaces forKey:@"interfaces"];

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:0 error:&error];

    // show
    [self appendLog:[NSString stringWithFormat:@"执行检测: %@", result] to:logTextArea timestamp:true];

    // post data
    [nNTraceTasks postResults:jsonData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self printInterfaceList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
