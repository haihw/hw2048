//
//  HWGamePlayViewController.h
//  game4096
//
//  Created by Hai Hw on 26/3/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import <iAd/iAd.h>
@interface HWGamePlayViewController : GAITrackedViewController
@property (strong, nonatomic) IBOutlet UIView *extraInfoView;

@property (strong, nonatomic) IBOutlet UIView *playView;
@property (strong, nonatomic) IBOutlet UILabel *bestScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *btnOption;
@property (strong, nonatomic) IBOutlet UIView *adBannerTopView, *adBannerBotView;
@property (strong, nonatomic) IBOutlet UIButton *btnRestart;
@property (strong, nonatomic) IBOutlet UIButton *btnRank;
@property (strong, nonatomic) IBOutlet ADBannerView *topAdbanner;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollExtracView;
@property (strong, nonatomic) IBOutlet UILabel *lbGuide;
- (IBAction)undoTapped:(id)sender;
- (IBAction)restartTapped:(id)sender;
- (IBAction)swipeDetected:(UISwipeGestureRecognizer *)sender;
- (IBAction)btnRankTapped:(id)sender;
- (IBAction)btnOptionsTapped:(id)sender;
- (IBAction)btnSettingTapped:(id)sender;

#pragma mark - gamekit
@property (nonatomic, assign)BOOL gameCenterEnabled;
@property (nonatomic, strong) NSString *leaderboardIdentifier;
@end
