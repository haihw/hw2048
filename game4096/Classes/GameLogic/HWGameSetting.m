//
//  HWGameLogic.m
//  game4096
//
//  Created by Hai Hw on 26/3/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWGameSetting.h"

@implementation HWGameSetting
+(id)SharedSetting {
    static dispatch_once_t pred;
    static HWGameSetting *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[HWGameSetting alloc] init];
        shared.originalImages = @[@"hw_2",
                                  @"hw_4",
                                  @"hw_8",
                                  @"hw_16",
                                  @"hw_32",
                                  @"hw_64",
                                  @"hw_128",
                                  @"hw_256",
                                  @"hw_512",
                                  @"hw_1024",
                                  @"hw_2048",
                                  @"hw_4092",
                                  @"hw_8192",
                                  @"hw_16384"];
        shared.girlImages = @[@"guy1",
                              @"guy2",
                              @"guy3",
                              @"guy4",
                              @"guy5",
                              @"guy6",
                              @"guy7",
                              @"guy8",
                              @"guy9",
                              @"guy10",
                              @"guy11",
                              @"guy12",
                              @"guy13",
                              @"guy14"];
        shared.fullgirlImages = @[@"fullguy1.jpg",
                                  @"fullguy2.jpg",
                                  @"fullguy3.jpg",
                                  @"fullguy4.jpg",
                                  @"fullguy5.jpg",
                                  @"fullguy6.jpg",
                                  @"fullguy7.jpg",
                                  @"fullguy8.jpg",
                                  @"fullguy9.jpg",
                                  @"fullguy10.jpg",
                                  @"fullguy11.jpg",
                                  @"fullguy12.jpg",
                                  @"fullguy13.jpg",
                                  @"fullguy14.jpg"];
        shared.isSoundEnabled = NO;
    });
    return shared;
}

@end
