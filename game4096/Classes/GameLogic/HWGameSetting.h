//
//  HWGameLogic.h
//  game4096
//
//  Created by Hai Hw on 26/3/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWGameSetting : NSObject
+(HWGameSetting *)SharedSetting;
@property (nonatomic, assign)BOOL isSoundEnabled;
@property (nonatomic, strong)NSArray *originalImages;
@property (nonatomic, strong)NSArray *girlImages;
@property (nonatomic, strong)NSArray *fullgirlImages;

- (NSString *)getDataPath;
- (NSString *)getServerPath;

@end
