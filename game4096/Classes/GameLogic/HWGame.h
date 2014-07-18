//
//  HWGame.h
//  game4096
//
//  Created by Hai Hw on 26/3/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol HWGameDelegate;
@class HWGamePlayViewController, HWGameCellView, PointObject;

@interface HWGame : NSObject
@property (nonatomic, strong) NSMutableArray *gameCells;
@property (nonatomic, assign) NSInteger targetNumber;
@property (nonatomic, assign) CGSize boardSize;
@property (nonatomic, assign) BOOL isWin;
@property (nonatomic, assign) NSInteger gameScore;
@property (nonatomic, weak) id <HWGameDelegate> delegate;
@property (nonatomic, assign) float highestValue;
- (void)startGame;
- (void)moveToDirection:(UISwipeGestureRecognizerDirection)direction;
@end

@protocol HWGameDelegate <NSObject>
- (void)resetBoard;
- (void)gameScoreChanged:(NSInteger)newScore;
- (void)bestScoreChanged:(NSInteger)newScore;
- (void)gameOver:(HWGame*)game;
- (HWGameCellView *)newCellAtPosition:(CGPoint)position;
- (void)moveCell:(HWGameCellView*)cell toNewPosition:(PointObject*)positionObj andDelete:(BOOL)needDelele;
@end
@interface PointObject : NSObject
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, strong) HWGameCellView *cell;
@end
