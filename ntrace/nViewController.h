//
//  nViewController.h
//  ntrace
//
//  Created by Liu Lantao on 13-5-2.
//  Copyright (c) 2013年 Liu Lantao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface nViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *logTextArea;

- (void)printInterfaceList;

- (IBAction)btnExecCheckClicked:(id)sender;

@end
