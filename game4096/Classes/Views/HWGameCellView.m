//
//  HWGameCellView.m
//  game4096
//
//  Created by Hai Hw on 26/3/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWGameCellView.h"
#import "HWGame.h"
@implementation HWGameCellView

- (id)initWithFrame:(CGRect)frame
{
        // Initialization code
    HWGameCellView *cell = [[[NSBundle mainBundle] loadNibNamed:@"HWGameCellView" owner:nil options:nil] firstObject];
    cell.frame = frame;
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)reset
{
    _label.text = @"";
}
- (void)moveToDirection:(UISwipeGestureRecognizerDirection)direction
{
    
}
- (void)active
{
    _label.alpha = 0;
    _label.text = @"2";
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _label.alpha = 1;
    } completion:nil];
}
@end
