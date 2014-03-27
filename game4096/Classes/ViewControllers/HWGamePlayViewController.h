//
//  HWGamePlayViewController.h
//  game4096
//
//  Created by Hai Hw on 26/3/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWGamePlayViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *playView;
@property (strong, nonatomic) IBOutlet UILabel *bestScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
- (IBAction)undoTapped:(id)sender;
- (IBAction)restartTapped:(id)sender;
- (IBAction)swipeDetected:(UISwipeGestureRecognizer *)sender;
@end
