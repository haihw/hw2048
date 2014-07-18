//
//  HWGame.m
//  game4096
//
//  Created by Hai Hw on 26/3/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWGame.h"
#import "HWGameCellView.h"
#import "HWGamePlayViewController.h"
@interface HWGame ()
{
    NSMutableArray *emptyCells;
    NSMutableArray *allCells;
}
@end
@implementation HWGame
- (id)init
{
    self  = [super init];
    if (self)
    {
        allCells = [NSMutableArray array];
        for (int i=0; i<kGameBoardSize; i++)
            for (int j=0; j<kGameBoardSize; j++) {
                CGPoint point = CGPointMake(i, j);
                PointObject *pObj = [[PointObject alloc] init];
                pObj.point = point;
                [allCells addObject:pObj];
            }
    }
    return self;
}
- (void)initGame
{
    emptyCells = [NSMutableArray arrayWithArray:allCells];
    _gameScore = 0;
    _highestValue = 0;
}
- (void)startGame
{
    [self initGame];
    //add 2 cell at the beginingz
    [self addRandomCell];
    [self addRandomCell];
}
- (BOOL)isGameOver
{
    //if there are any empty cell, game on
    if (emptyCells.count > 0) {
        return NO;
    }
    
    // if there are any 2 same value cell have same border, game on
    for (int row = 0; row<_boardSize.height; row++)
        for (int col = 0; col<_boardSize.width; col++)
        {
            PointObject *pObj = [allCells objectAtIndex:[self indexFromPoint:CGPointMake(col, row)]];
            if (row<_boardSize.width-1){
                PointObject *downObjt = [allCells objectAtIndex:[self indexFromPoint:CGPointMake(col, row+1)]];
                if (pObj.cell.value == downObjt.cell.value)
                    return NO;
            }
            if (col < _boardSize.height-1){
                PointObject *leftObjt = [allCells objectAtIndex:[self indexFromPoint:CGPointMake(col+1, row)]];
                if (pObj.cell.value == leftObjt.cell.value)
                    return NO;
            }
        }
    return YES;
}
- (void)checkGameOver
{
    if ([self isGameOver])
    {
        NSNumber *bestScore = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyBestScoreKey];
        if (!bestScore || bestScore.integerValue < _gameScore) {
            bestScore = [NSNumber numberWithInteger:_gameScore];
            [[NSUserDefaults standardUserDefaults] setObject:bestScore forKey:kKeyBestScoreKey];
            if (_delegate && [_delegate respondsToSelector:@selector(bestScoreChanged:)])
                [_delegate bestScoreChanged:_gameScore];

        }
        NSLog(@"Game Over");
        if (_delegate && [_delegate respondsToSelector:@selector(gameOver:)])
        {
            [_delegate gameOver:self];
        }
    }
}
- (void)moveToDirection:(UISwipeGestureRecognizerDirection)direction
{
    BOOL isChanged = [self checkMergeBoardMoveDirection:direction];
    BOOL canAddCell = NO;
    if (isChanged)
    {
        canAddCell = [self addRandomCell];
    }
    
    if (emptyCells.count == 0)
    {
        [self checkGameOver];
    }

}
- (BOOL)canMoveObjectAtRow:(int)row collumn:(int)col withMoveDelta:(CGPoint)delta
{
    BOOL isChanged = NO;
    PointObject *pObj = [allCells objectAtIndex:[self indexFromPoint:CGPointMake(col, row)]]; //col ~ x, row ~y
    HWGameCellView *cellView = pObj.cell;
    if (![emptyCells containsObject:pObj])
    {
        NSLog(@"%@ Found cell", NSStringFromCGPoint(pObj.point));
        CGPoint newPos = [self moveCellFrom:pObj withDirectionDelta:delta];
        if (!CGPointEqualToPoint(newPos, pObj.point))
        {
            NSLog(@"%@ moved dest", NSStringFromCGPoint(newPos));
            isChanged = YES;
            [emptyCells addObject:pObj];
            PointObject *destPointObj = [allCells objectAtIndex:[self indexFromPoint:newPos]];
            if ([emptyCells containsObject:destPointObj])
            {
                [_delegate moveCell:cellView toNewPosition:destPointObj andDelete:NO];
                destPointObj.cell = cellView;
                [emptyCells removeObject:destPointObj];
            } else
            {
                NSLog(@"Merged");
                [_delegate moveCell:cellView toNewPosition:destPointObj andDelete:YES];
            }
        }
    }
    return isChanged;
}

- (CGPoint)moveCellFrom:(PointObject*)pointObj withDirectionDelta:(CGPoint)delta
{
    CGPoint pos = pointObj.point;
    CGPoint newPos;
    do {
        newPos = CGPointMake(pos.x + delta.x, pos.y + delta.y);
        if ([self isInBoard:newPos] ){
            PointObject *newPointObj = [allCells objectAtIndex:[self indexFromPoint:newPos]];
            if (![emptyCells containsObject:newPointObj])
            {
                //check to merge
                if (newPointObj.cell.value == pointObj.cell.value){
                    newPointObj.cell.value += pointObj.cell.value;
                    self.gameScore += newPointObj.cell.value;
                    //disappear current cell
                    if (newPointObj.cell.value > _highestValue)
                        _highestValue = newPointObj.cell.value;
                    return newPos;
                }
                else{
                    return pos;
                }
            }
            pos = newPos;
        }
    }while ([self isInBoard:newPos]);
    return pos;
}
- (BOOL) isInBoard:(CGPoint)point
{
    return CGRectContainsPoint(CGRectMake(0, 0, _boardSize.width, _boardSize.height), point);
}

- (BOOL)moveHorizontallyWithLeft:(BOOL)isLeft
{
    if (!_delegate || ![_delegate respondsToSelector:@selector(moveCell:toNewPosition:andDelete:)])
        return NO;
    
    BOOL isChanged = FALSE;
    int dCol, startCol;
    if (isLeft){
        NSLog(@"MOVE LEFT");
        startCol = 0;
        dCol = 1;
    }
    else{
        NSLog(@"MOVE RIGHT");
        startCol = _boardSize.width-1;
        dCol = -1;
    }
    CGPoint moveDelta = CGPointMake(-dCol, 0);
    //travel each collumn
    for (int row=0; row<_boardSize.width; row++){
        int col = startCol;
        do {
            BOOL isMoved = [self canMoveObjectAtRow:row collumn:col withMoveDelta:moveDelta];
            if (isMoved)
                isChanged = YES;
            col += dCol;
        } while (col < _boardSize.width && col >= 0);
    }
    return isChanged;
}
- (BOOL)moveVerticallyUP:(BOOL)isUp
{
    if (!_delegate || ![_delegate respondsToSelector:@selector(moveCell:toNewPosition:andDelete:)])
        return NO;
    
    BOOL isChanged = FALSE;
    int dRow, startRow;
    if (isUp){
        NSLog(@"MOVE UP");
        startRow = 0;
        dRow = 1;
    }
    else{
        NSLog(@"MOVE DOWN");
        startRow = _boardSize.height-1;
        dRow = -1;
    }
    CGPoint moveDelta = CGPointMake(0, -dRow);
    //travel each collumn
    for (int col=0; col<_boardSize.width; col++){
        int row = startRow;
        do {
            BOOL isMoved = [self canMoveObjectAtRow:row collumn:col withMoveDelta:moveDelta];
            if (isMoved)
                isChanged = YES;
            row += dRow;
        } while (row < _boardSize.height && row >= 0);
    }
    return isChanged;
}
//return YES if has change
- (BOOL)checkMergeBoardMoveDirection:(UISwipeGestureRecognizerDirection)direction
{
    switch (direction) {
        case UISwipeGestureRecognizerDirectionUp:
            //check from most top cell
            return [self moveVerticallyUP:YES];
        case UISwipeGestureRecognizerDirectionDown:
            //check from most down cell
            return [self moveVerticallyUP:NO];
        case UISwipeGestureRecognizerDirectionLeft:
            //check from most left cell
            return [self moveHorizontallyWithLeft:YES];
        case UISwipeGestureRecognizerDirectionRight:
            //check from most right cell
            return [self moveHorizontallyWithLeft:NO];
        default:
            return NO;
    }
}
#pragma mark logic
- (BOOL)addRandomCell
{
    PointObject *pointObj = [self randomEmptyPosition];
    if (pointObj)
    {
        [emptyCells removeObject:pointObj];
        if (_delegate && [_delegate respondsToSelector:@selector(newCellAtPosition:)])
        {
            HWGameCellView *cell = [_delegate newCellAtPosition:pointObj.point];
            self.gameScore += cell.value;
            NSLog(@"New cell %@", NSStringFromCGPoint(pointObj.point));
            pointObj.cell = cell;
        }
        return YES;
    }
    return NO;
}
- (id)randomEmptyPosition{
    if (emptyCells.count == 0)
        return nil;
    int index = arc4random() % emptyCells.count;
    return emptyCells[index];
}
- (int)indexFromPoint: (CGPoint)point
{
    return point.x * kGameBoardSize + point.y;
}
- (CGPoint)pointFromIndex :(int)index
{
    return CGPointMake(index/kGameBoardSize, index %kGameBoardSize);
}
- (void)setGameScore:(NSInteger)gameScore
{
    _gameScore = gameScore;
    if (_delegate && [_delegate respondsToSelector:@selector(gameScoreChanged:)])
        [_delegate gameScoreChanged:_gameScore];
}
@end

@implementation PointObject
@end
