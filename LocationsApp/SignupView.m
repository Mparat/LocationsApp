//
//  SignupView.m
//  LocationsApp
//
//  Created by Meera Parat on 7/28/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "SignupView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@interface SignupView ()

@end

@implementation SignupView

@synthesize parseSignupVC;
@synthesize signupView;
@synthesize firstName;
@synthesize lastName;
@synthesize email;
@synthesize password;

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
    [self configureSignupViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)configureSignupViews
{
    parseSignupVC = [[PFSignUpViewController alloc] init];
    [parseSignupVC setDelegate:self];
//    [parseSignupVC setFields: PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsDismissButton | PFSignUpFieldsAdditional | PFSignUpFieldsEmail];
    [parseSignupVC setFields:PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsDismissButton | PFSignUpFieldsAdditional];
    
    signupView = parseSignupVC.signUpView;
    signupView.frame = self.view.frame;
    signupView.logo = nil;
    signupView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background2"]];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setImage:[UIImage imageNamed:@"DoneButton"] forState:UIControlStateNormal];
    [doneButton setFrame:CGRectMake(25, 375, 270, 45)];
    [doneButton addTarget:self action:@selector(signUpViewController:shouldBeginSignUp:) forControlEvents:UIControlEventAllTouchEvents];
    [signupView addSubview:doneButton];
    
    [signupView.signUpButton setBackgroundImage:[UIImage imageNamed:@"DoneButton"] forState:UIControlStateNormal];
    [signupView.signUpButton setBackgroundImage:[UIImage imageNamed:@"DoneButton"] forState:UIControlStateHighlighted];
    [self.view addSubview:signupView];

}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [signupView.usernameField setFrame:CGRectMake(25, 390/2, 270, 45)];
    [signupView.usernameField setPlaceholder:@"Email"];
    signupView.usernameField.textAlignment = NSTextAlignmentLeft;
    [signupView.usernameField setTextColor:[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0]];
    [signupView.usernameField setBackgroundColor:[UIColor whiteColor]];
    [signupView.usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    signupView.usernameField.layer.borderColor = [[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0] CGColor];
    
    [signupView.passwordField setFrame:CGRectMake(25, 530/2, 270, 45)];
    [signupView.passwordField setPlaceholder:@"Password"];
    signupView.passwordField.textAlignment = NSTextAlignmentLeft;
    [signupView.passwordField setTextColor:[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0]];
    [signupView.passwordField setBackgroundColor:[UIColor whiteColor]];
    [signupView.passwordField setBorderStyle:UITextBorderStyleRoundedRect];
    signupView.passwordField.layer.borderColor = [[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0] CGColor];
    
    [signupView.additionalField setFrame:CGRectMake(25, 125, 120, 45)];
    [signupView.additionalField setPlaceholder:@"First Name"];
    signupView.additionalField.textAlignment = NSTextAlignmentLeft;
    [signupView.additionalField setTextColor:[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0]];
    [signupView.additionalField setBackgroundColor:[UIColor whiteColor]];
    [signupView.additionalField setBorderStyle:UITextBorderStyleRoundedRect];
    signupView.additionalField.layer.borderColor = [[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0] CGColor];

    lastName = [[UITextField alloc] init];
    [lastName setFrame:CGRectMake(350/2, 125, 120, 45)];
    [lastName setPlaceholder:@"Last Name"];
    lastName.textAlignment = NSTextAlignmentLeft;
    [lastName setTextColor:[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0]];
    [lastName setBackgroundColor:[UIColor whiteColor]];
    [lastName setBorderStyle:UITextBorderStyleRoundedRect];
    lastName.layer.borderColor = [[UIColor colorWithRed:151.0 / 255.0 green:151.0 / 255.0 blue:151.0 / 255.0 alpha:1.0] CGColor];
//    [signupView addSubview:lastName];

    [signupView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [signupView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    [signupView.signUpButton setFrame:CGRectMake(25, 375, 270, 45)];

}

#pragma mark - Parse Sign up delegate methods

-(BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info
{
//    if (lastName.text != nil) {
//        <#statements#>
//    }
    return YES;
}

-(void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    NSLog(@"Sign up successful");
//    [[[UIApplication sharedApplication] delegate] performSelector:@selector(loginSuccessful)];

    UINavigationController *controller = [(AppDelegate *) [[UIApplication sharedApplication] delegate] navigationController];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //
    }];
    [self.navigationController presentViewController:controller animated:YES completion:^{
        //
    }];

//    [self.window setRootViewController:[self navigationController]];
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
