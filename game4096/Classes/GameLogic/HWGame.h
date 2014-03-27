//
//  HWGame.h
//  game4096
//
//  Created by Hai Hw on 26/3/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol HWGameDelegate;
@class HWGamePlayViewController, HWGameCellView;

@interface HWGame : NSObject
@property (nonatomic, strong) NSMutableArray *gameCells;
@property (nonatomic, assign) NSInteger targetNumber;
@property (nonatomic, assign) CGSize boardSize;
@property (nonatomic, assign) BOOL isWin;
@property (nonatomic, assign) NSInteger gameScore;
@property (nonatomic, weak) id <HWGameDelegate> delegate;
- (void)startGame;
- (void)moveToDirection:(UISwipeGestureRecognizerDirection)direction;
@end

@protocol HWGameDelegate <NSObject>
- (void)resetBoard;
- (void)gameOver:(HWGame*)game;
- (HWGameCellView *)newCellAtPosition:(CGPoint)position;
@end
@interface PointObject : NSObject
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, strong) HWGameCellView *cell;
@end
