//
//  GADMillennialExtras.h
//  MillennialAdapter
//
//  Copyright (c) 2014 Millennial Media Inc. All rights reserved.
//

#import "GADAdMobExtras.h"

#import <MillennialMedia/MMRequest.h>

@interface GADMillennialExtras : GADAdMobExtras

/*  Create an MMRequest object for passing user metadata with an ad request in order to display more targeted and relevant ads. Assign that object to the request variable. You may only use information that is accurate, and that you have permission to share.
 */
@property (nonatomic, retain) MMRequest *request;

@end
