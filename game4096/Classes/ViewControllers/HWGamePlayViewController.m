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
#import <JTSImageViewController/JTSImageViewController.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AudioFX.h"
@interface HWGamePlayViewController () <HWGameDelegate, GADBannerViewDelegate, UIAlertViewDelegate, ADBannerViewDelegate, UIGestureRecognizerDelegate, HWGameCellViewDelegate>
{
    HWGame *game;
    BOOL isStartedGame;
    ADBannerView *topBanner;
    GADBannerView *botBanner;
    SystemSoundID soundID;
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
    if ([UIScreen mainScreen].bounds.size.height <= 480)
    {
        _extraInfoView.hidden = YES;
    }
    [[_btnRestart layer] setBorderWidth:1.0f];
    [[_btnRestart layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    
    self.screenName  = @"Game Play View";
    topBanner = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    topBanner.delegate = self;
    topBanner.hidden = YES;
    [_adBannerTopView addSubview:topBanner];

    botBanner = [[GADBannerView alloc] initWithAdSize:GADAdSizeFullWidthPortraitWithHeight(50)];
    botBanner.adUnitID = kGADKey;
    botBanner.delegate = self;
    botBanner.hidden = YES;
    botBanner.rootViewController = self;
    [_adBannerBotView addSubview:botBanner];
    
    [self creatBoard];
    isStartedGame = NO;
    
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for
    // the simulator as well as any devices you want to receive test ads.
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    [botBanner loadRequest:request];
    
    NSNumber *bestScore = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyBestScoreKey];
    if (bestScore)
        _bestScoreLabel.text = bestScore.stringValue;
    else
        _bestScoreLabel.text = @"0";
    _scoreLabel.text = @"0";

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!isStartedGame)
    {
        [self restartTapped:nil];
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
    _scoreLabel.text = @"0";
    [game startGame];
}
- (void)gameOver:(HWGame *)game
{
    isStartedGame = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"Thank for playing" delegate:self cancelButtonTitle:@"Close" otherButtonTitles: @"Restart", nil];
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
    cell.fullimageNames = [(HWGameSetting*)[HWGameSetting SharedSetting] fullgirlImages];
    cell.delegate = self;
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
- (void)haveMovementWithMerge:(BOOL)hasMerged
{
    NSInteger randomNumber = arc4random() % 2;
    NSString *soundName = @"move";
    if (hasMerged)
    {
        soundName = @"merge1";
        if (randomNumber > 0)
            soundName = @"merge2";
    }
    [self playSoundName:soundName andExt:@"wav"];
}
#pragma mark alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0){
        //TODO: display GADInterstitial
        [self restartTapped:nil];
    }
}
#pragma mark iAd Delegate
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"iAd %@", error);
    banner.hidden = YES;
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    banner.hidden = NO;
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

#pragma mark - gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark - HwGameCellDelegate
- (void)gameCellWantToDisplayImage:(UIImage *)image
{
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = image;
    JTSImageViewController *imageVC = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundStyle_ScaledDimmedBlurred];
    [imageVC showFromViewController:self transition:JTSImageViewControllerTransition_FromOffscreen];
    
}
-(BOOL) playSoundFXnamed: (NSString*) vSFXName Loop: (BOOL) vLoop
{
    NSError *error;
    
    NSBundle* bundle = [NSBundle mainBundle];
    
    NSString* bundleDirectory = (NSString*)[bundle bundlePath];
    
    NSURL *url = [NSURL fileURLWithPath:[bundleDirectory stringByAppendingPathComponent:vSFXName]];
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if(vLoop)
        audioPlayer.numberOfLoops = -1;
    else
        audioPlayer.numberOfLoops = 0;
    
    BOOL success = YES;
    
    if (audioPlayer == nil)
    {
        success = NO;
    }
    else
    {
        success = [audioPlayer play];
    }
    return success;
}
-(void) playSoundName:(NSString *)name andExt:(NSString *)ext {
    NSLog(@"%@", name);
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    NSAssert(soundPath, @"Sound file not found");
    if (soundID > 0)
    {
        AudioServicesDisposeSystemSoundID(soundID);
    }
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
}
@end
