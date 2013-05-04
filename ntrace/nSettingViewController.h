//
//  nSettingViewController.h
//  NTrace
//
//  Created by Liu Lantao on 13-5-3.
//  Copyright (c) 2013年 Liu Lantao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingStore.h"

@interface nSettingViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *apiServerTxt;
@property (weak, nonatomic) IBOutlet UITextField *taskIDTxt;
@property (weak, nonatomic) IBOutlet UITextField *userIdentityTxt;

- (IBAction)saveBtnClicked:(id)sender;
- (IBAction)resetBtnClicked:(id)sender;

@end
