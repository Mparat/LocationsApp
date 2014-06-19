//
//  AppDelegate.m
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>
#import "HomepageTVC.h"
#import "MessageVC.h"
#import "Login.h"
#import "AddressBookTVC.h"
#import "AddContacts.h"
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
    
    [Parse setApplicationId:@"WJyPfvSQq1rKoGMlyTp13xNliwIiPyZz8RyaRXwy"
                  clientKey:@"r46J9MvgvF6pbnmO7PUsatJbseIbWJM2zqBjSvC4"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];

    if (![PFUser currentUser]) {
        [self.window setRootViewController:[self navigationController]];
    }
    else{
        [self loginSucessful];
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(UINavigationController *)navigationController
{
    PFLogInViewController *parseLoginVC = [[PFLogInViewController alloc] init];
    [parseLoginVC setDelegate:self];
    
    PFSignUpViewController *parseSignupVC = [[PFSignUpViewController alloc] init];
    [parseSignupVC setDelegate:self];
    
    [parseLoginVC setSignUpController:parseSignupVC];
    [parseLoginVC setFields:PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsSignUpButton | PFLogInFieldsUsernameAndPassword];
    
    return [[UINavigationController alloc] initWithRootViewController:parseLoginVC];
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


#pragma mark - Parse Login delegate methods

// on click of "submit" button, i'm guessing
// Sent to the delegate to determine whether the log in request should be submitted to the server.
-(BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password
{
    if (username && password && username.length != 0 && password.length != 0) {
        return YES;
        // begin login process;
    }
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}


- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    NSLog(@"Login successful");
    self.parseController.signedInUser = user;
    [self loginSucessful];
}

-(void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSLog(@"Login attempt failed with error: %@", error);
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Username or password incorrect"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
}

-(void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    NSLog(@"Login was cancelled");
}

-(void)loginSucessful
{
    self.parseController.signedInUser = [PFUser currentUser];
    
    HomepageTVC *homepage = [[HomepageTVC alloc] init];
    [homepage setLocationManager:self.locationManager];
    [homepage setParseController:self.parseController];
    homepage.signedInUser = self.parseController.signedInUser;
    UINavigationController *controller1 = [[UINavigationController alloc] initWithRootViewController:homepage];

    AddContacts *addContacts = [[AddContacts alloc] init];
    addContacts.locationManager = self.locationManager;
    addContacts.parseController = self.parseController;
    addContacts.signedInUser = self.parseController.signedInUser;
    UINavigationController *controller2 = [[UINavigationController alloc] initWithRootViewController:addContacts];
//    AddressBookTVC *addressBook = [[AddressBookTVC alloc] init];
//    addressBook.locationManager = self.locationManager;
//    addressBook.parseController = self.parseController;
//    addressBook.signedInUser = self.parseController.signedInUser;
//    UINavigationController *controller2 = [[UINavigationController alloc] initWithRootViewController:addressBook];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    NSArray *controllers = [NSArray arrayWithObjects:controller1, controller2, nil];
    tabBarController.viewControllers = controllers;
    
    UITabBarItem *chats = [[UITabBarItem alloc] initWithTitle:@"Messages" image:nil tag:0];
    UITabBarItem *addNew = [[UITabBarItem alloc] initWithTitle:@"Contacts" image:nil tag:1];
    
    tabBarController.tabBarItem = chats;
    tabBarController.tabBarItem = addNew;
    
    [self.window setRootViewController:tabBarController];
}

#pragma mark - Parse Sign up delegate methods

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    NSLog(@"Sign up successful");
    [self.window setRootViewController:[self navigationController]];
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error
{
    NSLog(@"Sign up failed with error: %@", error);
}

-(void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController
{
    NSLog(@"User cancelled sign up");
}

@end
