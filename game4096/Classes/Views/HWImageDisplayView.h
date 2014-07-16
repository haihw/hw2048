//
//  HWImageDisplayView.h
//  game4096
//
//  Created by Hai Hw on 7/7/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWImageDisplayView : UIView <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UIImageView *imageView;
}
@property (nonatomic, strong) UIImage *image;
- (id)initWithFrame:(CGRect) frame andImage:(UIImage*)image;
@end
