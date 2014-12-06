//
//  HWAppDelegate.m
//  game4096
//
//  Created by Hai Hw on 26/3/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWAppDelegate.h"
#import "HWGamePlayViewController.h"
#import "GAI.h"
#import "iRate.h"
#import <Crashlytics/Crashlytics.h>
#import <AdColony/AdColony.h>
#import <StartApp/StartApp.h>
@implementation HWAppDelegate

+ (void)initialize
{
    //configure iRate
    [iRate sharedInstance].daysUntilPrompt = 0;
    [iRate sharedInstance].usesUntilPrompt = 5;
    [iRate sharedInstance].appStoreID = kAppStoreID;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-38276506-10"];

    [Crashlytics startWithAPIKey:@"590e85a5e7df124780bb8476a41281f5b5f54469"];
    
    [AdColony configureWithAppID:kAdCololyAppID
                         zoneIDs:@[kAdCololyAdZoneID]
                        delegate:nil
                         logging:YES];
    
    STAStartAppSDK* sdk = [STAStartAppSDK sharedInstance];
    sdk.appID = kStartAppID;
    sdk.devID = kStartAppDevID;
    sdk.preferences = [STASDKPreferences prefrencesWithAge:25 andGender:STAGender_Male];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    HWGamePlayViewController *vc = [[HWGamePlayViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [navi setNavigationBarHidden:YES];
    self.window.rootViewController = navi;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
