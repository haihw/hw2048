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
@property (strong, nonatomic) NSArray *imageNames;
@property (strong, nonatomic) NSArray *colors;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) int value;
@property (nonatomic, strong) HWGame *game;
- (void)active;
- (void)reset;
- (void)sync;
@end
