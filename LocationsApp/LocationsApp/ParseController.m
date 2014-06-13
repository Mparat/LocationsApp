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

@synthesize currentUser = _currentUser;

-(void)launchParse
{
    //    if (![PFUser currentUser]) {
    //        parseLoginController = [[PFLogInViewController alloc] init];
    //        [parseLoginController setDelegate:self];
    //    }
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
//            [self.delegate loginSuccessful];
        }
    }];
}

@end