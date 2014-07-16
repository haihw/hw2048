//
//  HWImageDisplayView.m
//  game4096
//
//  Created by Hai Hw on 7/7/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWImageDisplayView.h"

@implementation HWImageDisplayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.image = image;
        scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        imageView = [[UIImageView alloc] initWithImage:image];
        scrollView.contentSize = imageView.frame.size;
        [scrollView addSubview:imageView];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}
- (IBAction)tapGesture:(id)sender
{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"scroll ended");
}
@end
