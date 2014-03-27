//
//  HWGameCellView.h
//  game4096
//
//  Created by Hai Hw on 26/3/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HWGame;
@interface HWGameCellView : UIView
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, strong) HWGame *game;
- (void)active;
- (void)reset;
- (void)moveToDirection:(UISwipeGestureRecognizerDirection) direction;
@end
