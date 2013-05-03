//
//  nSettingViewController.m
//  NTrace
//
//  Created by Liu Lantao on 13-5-3.
//  Copyright (c) 2013年 Liu Lantao. All rights reserved.
//

#import "nSettingViewController.h"

@interface nSettingViewController ()

@end

@implementation nSettingViewController

@synthesize apiServerTxt;
@synthesize taskIDTxt;
@synthesize userIdentityTxt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBtnCliecked:(id)sender {
    NSLog(@"saveBtnCliecked");
    [self.view endEditing:YES];
}
@end
