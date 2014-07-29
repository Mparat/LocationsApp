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
#import <QuartzCore/QuartzCore.h>
#import "HomepageTVC.h"
#import "MessageVC.h"
#import "AddressBookTVC.h"
#import "AddContacts.h"
#import "LocationManagerController.h"
#import "ParseController.h"
#import "User.h"
#import "FirstView.h"
#import <LayerKit/LayerKit.h>

@implementation AppDelegate

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize parseUserNumbers = _parseUserNumbers;
@synthesize parseUserUsernames = _parseUserUsernames;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    LYRClient *layerClient = [LYRClient clientWithAppID:[[NSUUID alloc] initWithUUIDString:@"4ecc1f16-0c5e-11e4-ac3e-276b00000a10"]];
    [layerClient connectWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"Sucessfully connected to Layer!");
        } else {
            NSLog(@"Failed connection to Layer with error: %@", error);
        }
    }];
    self.locationManager = [[LocationManagerController alloc] init];
    [self.locationManager launchLocationManager];
    
    self.parseController = [[ParseController alloc] init];
    [self.parseController launchParse];
    
    [Parse setApplicationId:@"WJyPfvSQq1rKoGMlyTp13xNliwIiPyZz8RyaRXwy"
                  clientKey:@"r46J9MvgvF6pbnmO7PUsatJbseIbWJM2zqBjSvC4"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    
//    if (![PFUser currentUser]) {
//        [self.window setRootViewController:[self navigationController]];
//    }
//    else{
//        [self loginSucessful];
//    }
    [self checkCurrentUser];
//    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)checkCurrentUser
{
    if (![PFUser currentUser]) {
        [self.window setRootViewController:[self navigationController]];
    }
    else{
        [self loginSucessful];
    }
    [self.window makeKeyAndVisible];
}

-(UINavigationController *)navigationController
{
    PFLogInViewController *parseLoginVC = [[PFLogInViewController alloc] init];
    [parseLoginVC setDelegate:self];
    
    PFSignUpViewController *parseSignupVC = [[PFSignUpViewController alloc] init];
    [parseSignupVC setDelegate:self];
    
    [parseLoginVC setSignUpController:parseSignupVC];
    [parseLoginVC setFields:PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsSignUpButton | PFLogInFieldsUsernameAndPassword];
    
    [parseSignupVC setFields:PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsAdditional | PFSignUpFieldsDismissButton | PFSignUpFieldsSignUpButton];

    [self configureLoginView:parseLoginVC];
    [self configureSignupView:parseSignupVC];
    
    FirstView *firstView = [[FirstView alloc] init];
    return [[UINavigationController alloc] initWithRootViewController:firstView];

//    return [[UINavigationController alloc] initWithRootViewController:parseLoginVC];
}

-(void)configureLoginView:(PFLogInViewController *)loginViewController
{
    PFLogInView *view = loginViewController.logInView;
    view.backgroundColor = [UIColor whiteColor];
    view.usernameField.backgroundColor = [UIColor grayColor];
    view.passwordField.backgroundColor = [UIColor grayColor];
    view.usernameField.borderStyle = UITextBorderStyleRoundedRect;
    view.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    view.passwordField.textColor = [UIColor whiteColor];
    view.usernameField.textColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"Title";
    [title sizeToFit];
    view.logo = title;
}

-(void)configureSignupView:(PFSignUpViewController *)signupViewController
{
    PFSignUpView *view = signupViewController.signUpView;
    [view.additionalField setPlaceholder:@"Name"];
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
    PFQuery *query = [PFUser query];
    [query whereKeyExists:@"phoneNumber"];
    [query whereKey:@"username" notEqualTo:self.parseController.signedInUser.username];
    self.parseUserNumbers = [NSMutableArray array];
    self.parseUserUsernames = [NSMutableArray array];

    NSArray *users = [query findObjects];
    for (int i = 0; i < [users count]; i++) {
        NSString *number = [[users objectAtIndex:i] objectForKey:@"phoneNumber"];
        NSString *username = [[users objectAtIndex:i] objectForKey:@"username"];
        [self.parseUserNumbers addObject:number];
        [self.parseUserUsernames addObject:username];
    }
    
    User *me = [[User alloc] init];
    me.username = self.parseController.signedInUser.username;
    me.phoneNumber = [self.parseController.signedInUser objectForKey:@"phoneNumber"];
    me.friends = [NSMutableArray array];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:me.username];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    me.messageRecipients = [NSMutableArray arrayWithArray:array];

    HomepageTVC *homepage = [[HomepageTVC alloc] init];
    [homepage setLocationManager:self.locationManager];
    [homepage setParseController:self.parseController];
    homepage.signedInUser = self.parseController.signedInUser;
    homepage.me = me;
    UINavigationController *controller1 = [[UINavigationController alloc] initWithRootViewController:homepage];

    AddressBookTVC *contacts = [[AddressBookTVC alloc] init];
    contacts.locationManager = self.locationManager;
    contacts.parseController = self.parseController;
    contacts.signedInUser = self.parseController.signedInUser;
    contacts.me = me;
    contacts.parseUserNumbers = self.parseUserNumbers;
    contacts.parseUserUsernames = self.parseUserUsernames;
    UINavigationController *controller2 = [[UINavigationController alloc] initWithRootViewController:contacts];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    NSArray *controllers = [NSArray arrayWithObjects:controller1, controller2, nil];
    tabBarController.viewControllers = controllers;
    
    UIImage *unselectedContacts = [UIImage imageNamed:@"UnselectedContacts"];
    UIImage *selectedContacts = [UIImage imageNamed:@"SelectedContacts"];
    UIImage *unselectedMessages = [UIImage imageNamed:@"UnselectedMessages"];
    UIImage *selectedMessages = [UIImage imageNamed:@"SelectedMessages"];
    UIColor *red = [UIColor colorWithRed:239.0/255.0 green:61.0/255.0 blue:91.0/255.0 alpha:1.0];

    selectedMessages = [selectedMessages imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller1.tabBarController.tabBar.selectedImageTintColor = red;

    selectedContacts = [selectedContacts imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller2.tabBarController.tabBar.selectedImageTintColor = red;

    UITabBarItem *chats = [[UITabBarItem alloc] initWithTitle:@"Messages" image:unselectedMessages selectedImage:selectedMessages];
    UITabBarItem *addNew = [[UITabBarItem alloc] initWithTitle:@"Contacts" image:unselectedContacts selectedImage:selectedContacts];

    [controller1 setTabBarItem:chats];
    [controller2 setTabBarItem:addNew];

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
