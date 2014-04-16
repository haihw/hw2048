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
        shared.girlImages = @[@"g1",
                              @"g2",
                              @"g3",
                              @"g4",
                              @"g5",
                              @"g6",
                              @"g7",
                              @"g8",
                              @"g9",
                              @"g10",
                              @"g11",
                              @"g12",
                              @"hw_8192",
                              @"hw_16384"];
    });
    return shared;
}

@end
