//
//  HWGamePlayViewController.m
//  game4096
//
//  Created by Hai Hw on 26/3/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWGamePlayViewController.h"
#import "HWGameCellView.h"
#import "HWGameLogic.h"
#import "HWGame.h"
@interface HWGamePlayViewController () <HWGameDelegate>
{
    HWGame *game;
    BOOL isStartedGame;
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
    [self creatBoard];
    isStartedGame = NO;
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
    [game moveToDirection:sender.direction];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"Thank for playing" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
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
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
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
@end

