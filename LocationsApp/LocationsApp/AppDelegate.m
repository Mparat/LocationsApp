//
//  AppDelegate.m
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>
#import "HomepageTVC.h"
#import "MessageVC.h"
#import "Login.h"
#import "LocationManagerController.h"
#import "ParseController.h"

@implementation AppDelegate

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.locationManager = [[LocationManagerController alloc] init];
    [self.locationManager launchLocationManager];
    
    self.parseController = [[ParseController alloc] init];
    [self.parseController launchParse];

    [self.window setRootViewController:[self navigationController]];
    [self.window makeKeyAndVisible];
    [Parse setApplicationId:@"WJyPfvSQq1rKoGMlyTp13xNliwIiPyZz8RyaRXwy"
                  clientKey:@"r46J9MvgvF6pbnmO7PUsatJbseIbWJM2zqBjSvC4"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    return YES;
}

-(UINavigationController *)navigationController
{
    Login *login = [[Login alloc] init];
    [login setLocationManager:self.locationManager];
    [login setParseController:self.parseController];
    UINavigationController *temp = [[UINavigationController alloc] initWithRootViewController:login];
    return temp;
//    HomepageTVC *homeTVC = [[HomepageTVC alloc] initWithStyle:UITableViewStyleGrouped];
//    return [[UINavigationController alloc] initWithRootViewController:homeTVC];
//    MessageVC *messageVC = [[MessageVC alloc] init];
//    return [[UINavigationController alloc] initWithRootViewController:messageVC];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

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

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
