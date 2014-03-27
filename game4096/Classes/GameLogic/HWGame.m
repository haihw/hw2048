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
}
- (void)startGame
{
    [self initGame];
    //add 2 cell at the beginingz
    [self addRandomCell];
    [self addRandomCell];
}
- (void)moveToDirection:(UISwipeGestureRecognizerDirection)direction
{
    if ([self checkMergeBoardMoveDirection:direction])
    {
        if (![self addRandomCell])
        {
            NSLog(@"Game Over");
            if (_delegate && [_delegate respondsToSelector:@selector(gameOver:)])
            {
                [_delegate gameOver:self];
            }
        }
    }

}
//return YES if has change
- (BOOL)checkMergeBoardMoveDirection:(UISwipeGestureRecognizerDirection)direction
{
    switch (direction) {
        case UISwipeGestureRecognizerDirectionUp:
            //check from most top cell
            break;
        case UISwipeGestureRecognizerDirectionDown:
            //check from most down cell
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            //check from most left cell
            break;
        case UISwipeGestureRecognizerDirectionRight:
            //check from most right cell
            break;
        default:
            break;
    }
    return YES;
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
    return point.y * kGameBoardSize + point.x;
}
- (CGPoint)pointFromIndex :(int)index
{
    return CGPointMake(index/kGameBoardSize, index %kGameBoardSize);
}

@end

@implementation PointObject
@end
