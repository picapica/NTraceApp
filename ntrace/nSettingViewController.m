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

    [self loadSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBtnClicked:(id)sender {
    [self saveSettings];
    
    [self.view endEditing:YES];
}

- (IBAction)resetBtnClicked:(id)sender {
    [SettingStore restoreDefaults];

    [self loadSettings];

    [self.view endEditing:YES];
}


- (void)loadSettings
{
    // load settings
    apiServerTxt.text = [SettingStore Values].apiServerTxt;
    taskIDTxt.text = [SettingStore Values].taskIDTxt;
    userIdentityTxt.text = [SettingStore Values].userIdentityTxt;
    
    // NSLog(@"loadSettings. %@ : %@; %@ : %@; %@ : %@;", @"apiServer", apiServerTxt.text, @"taskID", taskIDTxt.text, @"userIdentity", userIdentityTxt.text);
}

- (void)saveSettings
{
    // NSLog(@"saveBtnCliecked. %@ : %@; %@ : %@; %@ : %@;", @"apiServer", apiServerTxt.text, @"taskID", taskIDTxt.text, @"userIdentity", userIdentityTxt.text);
    
    [SettingStore Values].apiServerTxt = apiServerTxt.text;
    [SettingStore Values].taskIDTxt = taskIDTxt.text;
    [SettingStore Values].userIdentityTxt = userIdentityTxt.text;
}

@end
