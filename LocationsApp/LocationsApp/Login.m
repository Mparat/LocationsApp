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

@synthesize signedInUser = _signedInUser;
@synthesize parseUser;
@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;

//@synthesize parseLoginController = _parseLoginController;
//@synthesize parseSignUpController = _parseSignUpController;

@synthesize parseLoginView = _parseLoginView;
@synthesize parseSignUpView = _parseSignUpView;


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
    [self addLoginButon];
//    [self createParseLoginView];
//    NSLog(@"current user %@", [PFUser currentUser]);

//    [self checkForCachedUser];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.parseLoginController = [[PFLogInViewController alloc] init];
    [self.parseLoginController setDelegate:self.parseController];
    
    self.parseSignUpController = [[PFSignUpViewController alloc] init];
    [self.parseSignUpController setDelegate:self.parseController];
    
    [self.parseLoginController setSignUpController:self.parseSignUpController];
    
    [self.parseLoginController setFields:PFLogInFieldsFacebook | PFLogInFieldsLogInButton | PFLogInFieldsPasswordForgotten |PFLogInFieldsSignUpButton | PFLogInFieldsUsernameAndPassword];
    
//    self.parseLoginView = [[PFLogInView alloc] initWithFields:PFLogInFieldsDefault | PFLogInFieldsFacebook | PFLogInFieldsDismissButton];
//    self.parseLoginView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    
//    [self.view addSubview:self.parseLoginView];
    
    //    [self.parseController launchParseLogin:self.view];
    [self presentViewController:self.parseLoginController animated:YES completion:NULL];

}

-(void)createParseLoginView
{
    self.parseLoginController = [[PFLogInViewController alloc] init];
    [self.parseLoginController setDelegate:self];
    
    self.parseSignUpController = [[PFSignUpViewController alloc] init];
    [self.parseSignUpController setDelegate:self];
    
    [self.parseLoginController setSignUpController:self.parseSignUpController];

    
    self.parseLoginView = [[PFLogInView alloc] initWithFields:PFLogInFieldsDefault | PFLogInFieldsFacebook | PFLogInFieldsDismissButton];
    self.parseLoginView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:self.parseLoginView];
    
//    [self.parseController launchParseLogin:self.view];
    [self presentViewController:self.parseLoginController animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)checkForCachedUser
{
    if (![PFFacebookUtils isLinkedWithUser:parseUser]) {
        [PFFacebookUtils linkUser:parseUser permissions:nil block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"current user %@", [PFUser currentUser]);
                NSLog(@"Woohoo, user logged in with Facebook!");
            }
        }];
    }
    else{
        NSLog(@"current user %@", [PFUser currentUser]);
        NSLog(@"User is already linked with Facebook");
    }
    NSLog(@"current user %@", [PFUser currentUser]);
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        HomepageTVC *homepage = [[HomepageTVC alloc] init];
        self.parseUser = [PFUser currentUser]; // necessary?
//        [homepage setLocationManager:self.locationManager];
        homepage.parseUser = [PFUser currentUser];
        //            homepage.signedInUser = self.signedInUser;
        [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:homepage] animated:NO completion:^{
            //
        }];
    }
}


-(void)addLoginButon
{
    
    UIButton *parseButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 30, 300, 60, 30)];
    [parseButton setTitle:@"Login" forState:UIControlStateNormal];
    [parseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [parseButton addTarget:self action:@selector(loginWithParse) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:parseButton];
}

-(void)loginWithParse
{
    self.parseController.delegate = self;
    [self.parseController FBloginUser];
}

-(void)loginSuccessful
{
    self.signedInUser = self.parseController.signedInUser;
    HomepageTVC *homepage = [[HomepageTVC alloc] init];
//    self.parseUser = user; // necessary?
//    self.parseUser = [PFUser currentUser];
//    homepage.parseUser = user;
    [homepage setLocationManager:self.locationManager];
    [homepage setParseController:self.parseController];
//    signedInUser = [[User alloc] initWithName:@"Meera"];
    homepage.signedInUser = self.signedInUser;
    
    [self.navigationController pushViewController:homepage animated:YES];

}

@end
