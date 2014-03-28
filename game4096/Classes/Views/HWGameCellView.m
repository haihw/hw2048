//
//  HWGameCellView.m
//  game4096
//
//  Created by Hai Hw on 26/3/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "HWGameCellView.h"
#import "HWGame.h"
@implementation HWGameCellView

- (id)initWithFrame:(CGRect)frame
{
        // Initialization code
    HWGameCellView *cell = [[[NSBundle mainBundle] loadNibNamed:@"HWGameCellView" owner:nil options:nil] firstObject];
    cell.frame = frame;
    self.value = 0;
    self.layer.cornerRadius = 20;
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
- (void)active
{
    _label.alpha = 0;
    self.value = 2;
    [self sync];
    self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _label.alpha = 1;
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}
- (void)sync
{
    if (_value == 0)
        _label.text = @"";
    else
        _label.text = [NSString stringWithFormat:@"%d", _value];
    //color
    
}
@end
