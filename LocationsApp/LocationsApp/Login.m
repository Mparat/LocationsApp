//
//  Login.m
//  LocationsApp
//
//  Created by Meera Parat on 6/9/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "Login.h"
#import <FacebookSDK/FacebookSDK.h>
#import "HomepageTVC.h"
#import "User.h"
#import "LocationManagerController.h"
#import "ParseController.h"

@interface Login ()

@end

@implementation Login

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFLogInViewController *parseLoginVC = [[PFLogInViewController alloc] init];
    [parseLoginVC setDelegate:self];
    
    PFSignUpViewController *parseSignupVC = [[PFSignUpViewController alloc] init];
    [parseSignupVC setDelegate:self];
    
    [parseLoginVC setSignUpController:parseSignupVC];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:parseLoginVC];
    [self.navigationController presentViewController:controller animated:YES completion:^{
        //
    }];
    //    return [[UINavigationController alloc] initWithRootViewController:parseLoginVC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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


- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    NSLog(@"Login successful");
    [self loginSucessful];
}

-(void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSLog(@"Login attempt failed with error: %@", error);
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Username or password incorrect"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
}

-(void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    NSLog(@"Login was cancelled");
}

-(void)loginSucessful
{
    
    HomepageTVC *homepage = [[HomepageTVC alloc] init];
    [homepage setLocationManager:self.locationManager];
    [homepage setParseController:self.parseController];
    
    //    Login *login = [[Login alloc] init];
    //    [login setLocationManager:self.locationManager];
    //    [login setParseController:self.parseController];
    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:homepage];
    [self.navigationController pushViewController:controller animated:YES];
//    [self.window setRootViewController:controller];
    
}

@end