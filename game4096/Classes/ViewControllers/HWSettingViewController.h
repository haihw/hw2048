//
//  HWSettingViewController.h
//  game4096
//
//  Created by Hai Hw on 6/12/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWSettingViewController : UIViewController
+(HWSettingViewController *)SharedInstance;
- (IBAction)btnCloseTapped:(id)sender;
- (IBAction)btnRateTapped:(id)sender;
- (IBAction)btnRemoveAdTapped:(id)sender;
- (IBAction)switchSoundChanged:(id)sender;
- (IBAction)btnRestorePurchaseTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnRemoveAd;
@property (strong, nonatomic) IBOutlet UISwitch *switchSoundOption;
@property (assign) BOOL isRemovedAd;
@end
