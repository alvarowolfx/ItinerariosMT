//
//  IMTAppDelegate.m
//  Itinerarios MT
//
//  Created by Alvaro Viebrantz on 25/08/13.
//  Copyright (c) 2013 Agiratec. All rights reserved.
//

#import "IMTAppDelegate.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <FlatUIKit/FlatUIKit.h>

@implementation IMTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    [self setupGA];
    [self setupTheme];
    
    return YES;
}

-(void) setupGA{
    
    [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
    [[GAI sharedInstance] setDispatchInterval:20];
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelError];
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-37452057-3"];
    [[GAI sharedInstance] setDefaultTracker:tracker];
    
}

-(void) setupTheme{
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor cloudsColor]}];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0){
        [UIBarButtonItem configureFlatButtonsWithColor:[UIColor belizeHoleColor]
                                      highlightedColor:[UIColor midnightBlueColor]
                                          cornerRadius:3];
    }
    [[UINavigationBar appearance] setTintColor:[UIColor cloudsColor]];
    [[UITabBar appearance] setTintColor:[UIColor cloudsColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    /*
     [[UITabBarItem appearance] setTitleTextAttributes:@{
     UITextAttributeTextColor: [UIColor midnightBlueColor]
     }
     forState:UIControlStateNormal];
     [[UITabBarItem appearance] setTitleTextAttributes:@{
     UITextAttributeTextColor: [UIColor cloudsColor]
     }
     forState:UIControlStateSelected];
     */
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
