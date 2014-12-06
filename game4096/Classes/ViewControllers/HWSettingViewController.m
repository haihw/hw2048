//
//  HWSettingViewController.m
//  game4096
//
//  Created by Hai Hw on 6/12/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWSettingViewController.h"

@interface HWSettingViewController ()

@end

@implementation HWSettingViewController
+(id)SharedInstance {
    static dispatch_once_t pred;
    static HWSettingViewController *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[HWSettingViewController alloc] init];
    });
    return shared;
}

- (IBAction)btnCloseTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnRateTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%d", kAppStoreID]]];
}

- (IBAction)btnRemoveAdTapped:(id)sender {
}

- (IBAction)switchSoundChanged:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
