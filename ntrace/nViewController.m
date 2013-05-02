//
//  nViewController.m
//  ntrace
//
//  Created by Liu Lantao on 13-5-2.
//  Copyright (c) 2013年 Liu Lantao. All rights reserved.
//

#import "nViewController.h"
#import "NetInterface.h"

@interface nViewController ()

@end

@implementation nViewController

@synthesize logTextArea;

- (void)appendLog:(NSString *)logmessage to:(UITextView *)area {
    NSString *logcache = area.text;
    NSLog(@"%@\n", logcache);
    
    NSLog(@"%@\n", [logcache stringByAppendingString:logmessage]);
    area.text = [[logcache stringByAppendingString:logmessage] stringByAppendingString:@"\n"];
}

- (void)printInterfaceList{
    NSMutableDictionary* allInterfaceList = [NetInterface getInterfaceList];
    for (NSString* name in allInterfaceList)
    {
        [self appendLog:[NSString stringWithFormat:@"Interface %@ : %@", name, [allInterfaceList objectForKey:name]] to:logTextArea];
    }
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
