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
#import "UIColor+HexColor.h"
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
    switch (_value) {
        case 2:
            self.label.backgroundColor = [UIColor colorFromHex:HexColor24Sinbad];
            self.label.textColor = [UIColor colorFromHex:HexColor23EggWhite];
            break;
        case 4:
            self.label.backgroundColor = [UIColor colorFromHex:HexColor12DodgeBlue];
            self.label.textColor = [UIColor colorFromHex:HexColor13PeachOrange];
            break;
        case 8:
            self.label.backgroundColor = [UIColor colorFromHex:HexColor13PeachOrange];
            self.label.textColor = [UIColor colorFromHex:HexColor14OrangeRed];
            break;
        case 16:
            self.label.backgroundColor = [UIColor colorFromHex:HexColor14OrangeRed];
            self.label.textColor = [UIColor colorFromHex:HexColor11MidNightBlue];
            break;
        case 32:
            self.label.backgroundColor = [UIColor colorFromHex:HexColor11MidNightBlue];
            self.label.textColor = [UIColor colorFromHex:HexColor13PeachOrange];
            break;
        case 64:
            self.label.backgroundColor = [UIColor colorFromHex:HexColor12DodgeBlue];
            self.label.textColor = [UIColor colorFromHex:HexColor14OrangeRed];
            break;
        case 128:
            self.label.backgroundColor = [UIColor colorFromHex:HexColor12DodgeBlue];
            self.label.textColor = [UIColor colorFromHex:HexColor11MidNightBlue];
            break;
        case 256:
            self.label.backgroundColor = [UIColor colorFromHex:HexColor24Sinbad];
            self.label.textColor = [UIColor colorFromHex:HexColor25BitterSweet];
            break;
        case 512:
            self.label.backgroundColor = [UIColor colorFromHex:HexColor23EggWhite];
            self.label.textColor = [UIColor colorFromHex:HexColor24Sinbad];
            break;
        case 1024:
            self.label.backgroundColor = [UIColor colorFromHex:HexColor21BlueChill];
            self.label.textColor = [UIColor colorFromHex:HexColor24Sinbad];
            break;
        case 2048:
            self.label.backgroundColor = [UIColor colorFromHex:HexColor22Emperor];
            self.label.textColor = [UIColor colorFromHex:HexColor24Sinbad];
            break;
        case 4096:
            self.label.backgroundColor = [UIColor colorFromHex:HexColor25BitterSweet];
            self.label.textColor = [UIColor colorFromHex:HexColor21BlueChill];
            break;

        default:
            break;
    }
}
@end
