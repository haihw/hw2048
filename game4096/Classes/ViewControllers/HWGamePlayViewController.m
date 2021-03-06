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
#import "HWSettingViewController.h"

#import <GoogleMobileAds/GoogleMobileAds.h>
#import <StartApp/StartApp.h>
#import <JTSImageViewController/JTSImageViewController.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AudioFX.h"
#import "MBProgressHUD.h"
#import <GameKit/GameKit.h>
@interface HWGamePlayViewController () <HWGameDelegate, GADBannerViewDelegate, UIAlertViewDelegate, ADBannerViewDelegate, UIGestureRecognizerDelegate, HWGameCellViewDelegate, GKGameCenterControllerDelegate, GADInterstitialDelegate, STABannerDelegateProtocol, JTSImageViewControllerInteractionsDelegate, UIActionSheetDelegate>
{
    HWGame *game;
    BOOL isStartedGame, isFirstLoad;
    ADBannerView *iadBanner;
    STABannerView *startAppBanner;
    GADBannerView *admobBanner;
    GADInterstitial *interstitialAd;
    STAStartAppAd* startAppAd;    // ADD THIS LINE
    SystemSoundID soundID;
    
    UIImage *showingImage;
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
- (void)sendGADInterstitialRequest
{
    if ([HWSettingViewController SharedInstance].isRemovedAd)
        return;
//    interstitialAd = [[GADInterstitial alloc] init];
//    interstitialAd.adUnitID = kGADInterstitialID;
//    interstitialAd.delegate = self;
//    [interstitialAd loadRequest:[GADRequest request]];
//    [AdColony playVideoAdForZone:kAdCololyAdZoneID withDelegate:nil];
    [startAppAd showAd];

}
- (void)setupAdBanner
{
    if ([HWSettingViewController SharedInstance].isRemovedAd)
        return;
    
    iadBanner = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    iadBanner.delegate = self;
    iadBanner.hidden = YES;
    
    startAppBanner = [[STABannerView alloc] initWithSize:STA_AutoAdSize autoOrigin:STAAdOrigin_Bottom
                                                withView:self.view withDelegate: self];
    [startAppBanner showBanner];
//    admobBanner = [[GADBannerView alloc] initWithAdSize:GADAdSizeFullWidthPortraitWithHeight(50)];
//    admobBanner.adUnitID = kGADBannerID;
//    admobBanner.delegate = self;
//    admobBanner.hidden = YES;
//    admobBanner.rootViewController = self;
//    GADRequest *request = [GADRequest request];
//    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
//    [admobBanner loadRequest:request];
//    [_adBannerBotView addSubview:admobBanner];
    
    [_adBannerBotView addSubview:startAppBanner];
    [_adBannerBotView addSubview:iadBanner];
    
    startAppBanner.hidden = YES;
    startAppAd = [[STAStartAppAd alloc] init];
}
- (void)initializeGameEnviroinment{
    // Do any additional setup after loading the view from its nib.
    if ([UIScreen mainScreen].bounds.size.height > 480)
    {
        _lbGuide.hidden = NO;
    } else{
        _lbGuide.hidden = YES;
    }
    [[_btnRestart layer] setBorderWidth:1.0f];
    [[_btnRestart layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [[_playView layer] setBorderWidth:1.0f];
    [[_playView layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [_btnOption setSelected:[HWGameSetting SharedSetting].isSoundEnabled];
    self.screenName  = @"Game Play View";
    [self setupAdBanner];
    [self creatBoard];
    isStartedGame = NO;
    
    NSNumber *bestScore = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyBestScoreKey];
    if (bestScore)
        _bestScoreLabel.text = bestScore.stringValue;
    else
        _bestScoreLabel.text = @"0";
    _scoreLabel.text = @"0";
    _gameCenterEnabled = NO;
    [self authenticateLocalPlayer];
    isFirstLoad = YES;
    
}
- (NSArray *)getMissingImageFileNames{
    NSError *error;
    NSString *dataPath = [[HWGameSetting SharedSetting] getDataPath];
    NSLog(@"Path: %@", dataPath);
    NSMutableArray *resourceFileNames = [NSMutableArray array];
//    for (NSString *name in [HWGameSetting SharedSetting].girlImages){
//        [resourceFileNames addObject: [name stringByAppendingString:@"@2x.png"]];
//    }
    for (NSString *name in [HWGameSetting SharedSetting].fullgirlImages){
        [resourceFileNames addObject: name];
    }

    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
        return resourceFileNames;
    }
    
    NSMutableArray *missingResoureNames = [NSMutableArray array];
    for (NSString *name in resourceFileNames){
        NSString *filePath = [dataPath stringByAppendingFormat:@"/%@", name];
        //TODO: should check if file is corrupted or not
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
            [missingResoureNames addObject:name];
        }
    }
    return missingResoureNames;
}
- (void)downloadResources:(NSArray *)resourceNames
        completionHandler:(void (^)(BOOL success)) handler {
    __block NSInteger nDownloading = resourceNames.count;
    __block BOOL anyError = NO;
    if (nDownloading == 0){
        handler(YES);
        return;
    }
    NSString *serverPath = [[HWGameSetting SharedSetting] getServerPath];
    NSString *localPath = [[HWGameSetting SharedSetting] getDataPath];
    for (NSString *name in resourceNames){
        NSString *url = [serverPath stringByAppendingString:name];
        NSString *localFilePath = [localPath stringByAppendingFormat:@"/%@", name];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error) {
                NSLog(@"Download Error:%@",error.description);
                anyError = YES;
            }else if (data) {
                [data writeToFile:localFilePath atomically:YES];
                NSLog(@"File is saved to %@",localFilePath);
            }
            nDownloading --;
            if (nDownloading == 0){
                handler (!anyError);
            }
        }];
    }
}
- (void)checkingResourcesAndStartGame{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Checking...";
    
    NSArray *missingResourceFileNames = [self getMissingImageFileNames];
    [self downloadResources:missingResourceFileNames completionHandler:^(BOOL success) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!success){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Cannot download extra resource, the game will start now" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
        [self initializeGameEnviroinment];
    }];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkingResourcesAndStartGame];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [startAppAd loadAd];  // Add this line
    //only auto start game if it is the first load
    if (isFirstLoad)
    {
        [self restartTapped:nil];
        isFirstLoad = NO;
    }
    
    _btnOption.selected = [HWGameSetting SharedSetting].isSoundEnabled;
    if ([HWSettingViewController SharedInstance].isRemovedAd)
    {
        _adBannerBotView.hidden = YES;
        _adBannerTopView.hidden = YES;
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
    [self sendGADInterstitialRequest]; //debug
}

- (IBAction)swipeDetected:(UISwipeGestureRecognizer *)sender {
    if (!isStartedGame)
    {
        return;
    }
    if (sender.state == UIGestureRecognizerStateRecognized){
        [game moveToDirection:sender.direction];
        
    }
}

- (IBAction)btnRankTapped:(id)sender {
    [self showLeaderboardAndAchievements:YES];
}

- (IBAction)btnOptionsTapped:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
    [HWGameSetting SharedSetting].isSoundEnabled = sender.isSelected;
}

- (IBAction)btnSettingTapped:(id)sender {
    [self presentViewController:[HWSettingViewController SharedInstance] animated:YES completion:nil];
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
    //show interstitial ad
    isStartedGame = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"Thank for playing" delegate:self cancelButtonTitle:@"Close" otherButtonTitles: @"Restart", nil];
    [alert show];
    [self reportScore:_scoreLabel.text.integerValue];
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
    [self sendGADInterstitialRequest];
    if (buttonIndex > 0){
        [self restartTapped:nil];
    }
}
#pragma mark iAd Delegate
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"iAd %@", error);
    [self showBanner:startAppBanner];
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self showBanner:banner];
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
    [self showBanner:view];
    view.hidden = NO;
}
- (void)adViewWillLeaveApplication:(GADBannerView *)adView
{
    
}
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    NSLog(@"GADinterstitial Loaded");
    [ad presentFromRootViewController:self];
}
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"GADinterstitial %@", error);
}
#pragma mark - gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark - HwGameCellDelegate
- (void)gameCellWantToDisplayImage:(UIImage *)image
{
    if (image){
        showingImage = image;
        JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
        imageInfo.image = image;
        JTSImageViewController *imageVC = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle: JTSImageViewControllerBackgroundOption_Blurred];
        imageVC.interactionsDelegate = self;
        [imageVC showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
    }
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
    if (![HWGameSetting SharedSetting].isSoundEnabled)
        return;
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
#pragma mark game center

-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            
            else{
                _gameCenterEnabled = NO;
            }
        }
    };
}
-(void)reportScore:(NSInteger)newScore{
    if (!_gameCenterEnabled || !_leaderboardIdentifier) {
        return;
    }
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
    if (!score)
        return;
    score.value = newScore;
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}
-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    if (!_gameCenterEnabled) {
        [self authenticateLocalPlayer];
        return;
    }
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    [self presentViewController:gcViewController animated:YES completion:nil];
}
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - STABannerDelegateProtocol
- (void)didClickBannerAd:(STABannerView *)banner
{
    
}
- (void) didDisplayBannerAd:(STABannerView*)banner
{
    NSLog(@"LOADED STARTAPP Banner");
    [self showBanner:banner];
}
- (void) failedLoadBannerAd:(STABannerView*)banner withError:(NSError *)error
{
    [self showBanner:iadBanner];
    NSLog(@"%@", error.localizedDescription);
}

- (void)showBanner:(UIView *)banner
{
    admobBanner.hidden = YES;
    startAppBanner.hidden = YES;
    iadBanner.hidden = YES;
    banner.hidden = NO;
}

#pragma mark - JTSImageViewControllerInteractionsDelegate
- (void)imageViewerDidLongPress:(JTSImageViewController *)imageViewer atRect:(CGRect)rect
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Save Photo", nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
        UIImageWriteToSavedPhotosAlbum(showingImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.presentedViewController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"Photo is saved";
    [hud hide:YES afterDelay:0.5f];
}
@end
