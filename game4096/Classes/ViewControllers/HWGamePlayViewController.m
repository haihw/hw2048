//
//  HWGamePlayViewController.m
//  game4096
//
//  Created by Hai Hw on 26/3/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWGamePlayViewController.h"
#import "HWGameCellView.h"
#import "HWGameSetting.h"
#import "HWGame.h"
#import <iAd/iAd.h>
#import "GADBannerView.h"
@interface HWGamePlayViewController () <HWGameDelegate, GADBannerViewDelegate, UIAlertViewDelegate, ADBannerViewDelegate>
{
    HWGame *game;
    BOOL isStartedGame;
    GADBannerView *topBanner;
    GADBannerView *botBanner;
}
@end

@implementation HWGamePlayViewController

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
    // Do any additional setup after loading the view from its nib.
    topBanner = [[GADBannerView alloc] initWithAdSize:GADAdSizeFullWidthPortraitWithHeight(50)];
    topBanner.adUnitID = kGADKey;
    topBanner.delegate = self;
    topBanner.rootViewController = self;
    [_adBannerTopView addSubview:topBanner];

    botBanner = [[GADBannerView alloc] initWithAdSize:GADAdSizeFullWidthPortraitWithHeight(50)];
    botBanner.adUnitID = kGADKey;
    botBanner.delegate = self;
    botBanner.rootViewController = self;
    [_adBannerBotView addSubview:botBanner];
    
    [self creatBoard];
    isStartedGame = NO;
    
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for
    // the simulator as well as any devices you want to receive test ads.
    request.testDevices = [NSArray arrayWithObjects:@"2e403e244cdcff906eb2c2c4a52fc382", GAD_SIMULATOR_ID, nil];
    [topBanner loadRequest:request];
    [botBanner loadRequest:request];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSNumber *bestScore = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyBestScoreKey];
    if (bestScore)
        _bestScoreLabel.text = bestScore.stringValue;
    else
        _bestScoreLabel.text = @"0";
    _scoreLabel.text = @"0";
    if (!isStartedGame)
    {
        [self startGame];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)undoTapped:(id)sender {
    
}

- (IBAction)restartTapped:(id)sender {
    [self resetBoard];
    [self startGame];
}

- (IBAction)swipeDetected:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized){
        [game moveToDirection:sender.direction];
    }
}

#pragma mark - gameplay
- (void)creatBoard
{
    game = [[HWGame alloc] init];
    NSMutableArray *cells = [NSMutableArray array];
    game.gameCells = cells;
    game.boardSize = CGSizeMake(kGameBoardSize, kGameBoardSize);
    game.targetNumber = kGameTargetNumber;
    game.delegate = self;
}
- (void)startGame
{
    isStartedGame = YES;
    [game startGame];
}
- (void)gameOver:(HWGame *)game
{
    isStartedGame = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"Thank for playing" delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}
- (void)resetBoard
{
    for (UIView *view in game.gameCells)
    {
        [view removeFromSuperview];
    }
    [game.gameCells removeAllObjects];
}
- (HWGameCellView*) newCellAtPosition:(CGPoint)position
{
    float cellW = CGRectGetWidth(_playView.frame)/kGameBoardSize;
    float cellH = CGRectGetHeight(_playView.frame)/kGameBoardSize;
    HWGameCellView *cell = [[HWGameCellView alloc] initWithFrame:CGRectMake(position.x * cellW, position.y * cellH, cellW, cellH)];
    cell.game = game;
    cell.position = position;
    cell.imageNames = [(HWGameSetting*)[HWGameSetting SharedSetting] girlImages];
    [cell active];
    [_playView addSubview:cell];
    [game.gameCells addObject:cell];
    return cell;
}
- (void)moveCell:(HWGameCellView *)cell toNewPosition:(PointObject *)positionObj andDelete:(BOOL)needDelele
{
    [cell.superview bringSubviewToFront:cell];
    cell.position = positionObj.point;
    float cellW = CGRectGetWidth(_playView.frame)/game.boardSize.width;
    float cellH = CGRectGetHeight(_playView.frame)/game.boardSize.height;
    [UIView animateWithDuration:kAnimationMoveDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        cell.frame = CGRectMake(cell.position.x * cellW, cell.position.y * cellH, cellW, cellH);
    } completion:^(BOOL finished) {
        if (needDelele){
            [cell removeFromSuperview];
            [positionObj.cell sync];
        }
    }];
}
- (void)gameScoreChanged:(NSInteger)newScore
{
    _scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)newScore];
}
- (void)bestScoreChanged:(NSInteger)newScore
{
    _bestScoreLabel.text = [NSString stringWithFormat:@"%ld", (long)newScore];
}

#pragma mark alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self restartTapped:nil];
}
#pragma mark iAd Delegate
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"iAd %@", error);
    topBanner.hidden = NO;
    botBanner.hidden = NO;
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    topBanner.hidden = YES;
    botBanner.hidden = YES;
    NSLog(@"iAd loaded");
}
#pragma mark GADDelegate
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"GAD %@", error);
    view.hidden = YES;
}
- (void)adViewDidReceiveAd:(GADBannerView *)view{
    NSLog(@"GAD loaded");
    view.hidden = NO;
}
- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
    
}
@end

