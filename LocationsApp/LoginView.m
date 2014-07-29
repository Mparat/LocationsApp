//
//  LoginView.m
//  LocationsApp
//
//  Created by Meera Parat on 7/28/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "LoginView.h"
#import <QuartzCore/QuartzCore.h>
#import "FirstView.h"
#import "HomepageTVC.h"
#import "AddressBookTVC.h"
#import "AppDelegate.h"
#import "SignupView.h"

@interface LoginView ()

@end

@implementation LoginView

@synthesize parseLoginVC;
@synthesize loginView;
@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize parseUserNumbers = _parseUserNumbers;
@synthesize parseUserUsernames = _parseUserUsernames;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self configureLoginView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureLoginView
{
    parseLoginVC = [[PFLogInViewController alloc] init];
    [parseLoginVC setDelegate:self];
    [parseLoginVC setFields:PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsUsernameAndPassword | PFLogInFieldsDismissButton];
    SignupView *signupView = [[SignupView alloc] init];
    [parseLoginVC setSignUpController:signupView.parseSignupVC];
    loginView = parseLoginVC.logInView;
    loginView.frame = self.view.frame;
    loginView.logo = nil;
    loginView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background1"]];
    loginView.externalLogInLabel.hidden = YES;
    
    [loginView.logInButton setBackgroundImage:[UIImage imageNamed:@"DoneButton"] forState:UIControlStateNormal];
    [loginView.logInButton setBackgroundImage:[UIImage imageNamed:@"DoneButton"] forState:UIControlStateHighlighted];
    [self.view addSubview:loginView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [loginView.usernameField setFrame:CGRectMake(25, 125, 270, 45)];
    [loginView.usernameField setPlaceholder:@"Email"];
//    loginView.usernameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:34.0]}];
    loginView.usernameField.textAlignment = NSTextAlignmentLeft;
    [loginView.usernameField setTextColor:[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0]];
    [loginView.usernameField setBackgroundColor:[UIColor whiteColor]];
    [loginView.usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    loginView.usernameField.layer.borderColor = [[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0] CGColor];
    
    [loginView.passwordField setFrame:CGRectMake(25, 195, 270, 45)];
    [loginView.passwordField setPlaceholder:@"Password"];
    loginView.passwordField.textAlignment = NSTextAlignmentLeft;
    [loginView.passwordField setTextColor:[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0]];
    [loginView.passwordField setBackgroundColor:[UIColor whiteColor]];
    [loginView.passwordField setBorderStyle:UITextBorderStyleRoundedRect];
    loginView.passwordField.layer.borderColor = [[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0] CGColor];
    
    
    [loginView.logInButton setTitle:@"" forState:UIControlStateNormal];
    [loginView.logInButton setTitle:@"" forState:UIControlStateHighlighted];
    [loginView.logInButton setFrame:CGRectMake(25, 300, 270, 45)];

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
                                message:@"Make sure you fill out all fields"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}


- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    NSLog(@"Login successful");
    self.parseController.signedInUser = user;
//    [(AppDelegate *)[[UIApplication sharedApplication] delegate] performSelector:@selector(loginSuccessful)];

//    UINavigationController *controller = [(AppDelegate *) [[UIApplication sharedApplication] delegate] loginSuccessful];
//    [self.navigationController dismissViewControllerAnimated:YES completion:^{
//        //
//    }];
//    [self.navigationController presentViewController:controller animated:YES completion:^{
//        //
//    }];
    
//    [controller loginSucessful];
}

-(void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSLog(@"Login attempt failed with error: %@", error);
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Email or password incorrect"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
}

-(void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
//    FirstView *firstView = [[FirstView alloc] init];
//    [loginView removeFromSuperview];
//    [parseLoginVC dismissViewControllerAnimated:YES completion:^{
//        //
//    }];
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
//    [self.navigationController pushViewController:firstView animated:YES];
    UINavigationController *controller = [(AppDelegate *) [[UIApplication sharedApplication] delegate] navigationController];
    [parseLoginVC dismissViewControllerAnimated:YES completion:^{
        [loginView removeFromSuperview];
    }];
    [self.navigationController presentViewController:controller animated:YES completion:^{
        //
    }];
}

@end
