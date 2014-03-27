//
//  HWGameLogic.m
//  game4096
//
//  Created by Hai Hw on 26/3/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWGameLogic.h"

@implementation HWGameLogic
+(id)SharedLogic {
    static dispatch_once_t pred;
    static HWGameLogic *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[HWGameLogic alloc] init];
    });
    return shared;
}
#pragma mark - game logic

- (int)indexFromPoint: (CGPoint)point
{
    return point.y * kGameBoardSize + point.x;
}
- (CGPoint)pointFromIndex :(int)index
{
    return CGPointMake(index/kGameBoardSize, index %kGameBoardSize);
}

@end
