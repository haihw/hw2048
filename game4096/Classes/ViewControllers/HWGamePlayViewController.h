//
//  HWGamePlayViewController.h
//  game4096
//
//  Created by Hai Hw on 26/3/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
@interface HWGamePlayViewController : GAITrackedViewController
@property (strong, nonatomic) IBOutlet UIView *extraInfoView;

@property (strong, nonatomic) IBOutlet UIView *playView;
@property (strong, nonatomic) IBOutlet UILabel *bestScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIView *adBannerTopView, *adBannerBotView;
- (IBAction)undoTapped:(id)sender;
- (IBAction)restartTapped:(id)sender;
- (IBAction)swipeDetected:(UISwipeGestureRecognizer *)sender;
@end
