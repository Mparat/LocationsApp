//
//  ParseController.m
//  LocationsApp
//
//  Created by Meera Parat on 6/12/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "ParseController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"

@implementation ParseController

@synthesize signedInUser = _signedInUser;
@synthesize logInController = _logInController;
@synthesize signUpController = _signUpController;

@synthesize parseLoginView = _parseLoginView;
@synthesize parseSignUpView = _parseSignUpView;

@synthesize currentUser = _currentUser;

-(void)launchParse
{
//    if (![PFUser currentUser]) {
//        parseLoginController = [[PFLogInViewController alloc] init];
//        [parseLoginController setDelegate:self];
//    }
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
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    NSLog(@"Login successful");
    self.currentUser = user;
    [self.delegate loginSuccessful];
}

-(void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSLog(@"Login attempt failed with error: %@", error);
}

-(void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    NSLog(@"Login was cancelled");
}

#pragma mark - Parse Signup ViewController delegate methods

-(BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info
{
    BOOL informationComplete = YES;
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"Sign up complete");
//    [self dismissModalViewControllerAnimated:YES];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

-(void)FBloginUser
{
    [PFFacebookUtils logInWithPermissions:@[@"public_profile", @"email", @"user_friends"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
            [self.delegate loginSuccessful];
        }
    }];
}

-(void)FBlogoutUser
{
    [PFUser logOut];
    [self.delegate logoutSuccessful];
}

@end
