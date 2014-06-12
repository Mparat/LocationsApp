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

@synthesize signedInUser;
@synthesize parseUser;
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
    [self addNavBar];
    [self addLoginButon];
    //    NSLog(@"current user %@", [PFUser currentUser]);

//    [self checkForCachedUser];
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

-(void)addNavBar
{
    self.navigationItem.title = @"";
}


-(void)addLoginButon
{
    UIButton *parseButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 30, 300, 60, 30)];
    [parseButton setTitle:@"Login" forState:UIControlStateNormal];
    [parseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [parseButton addTarget:self action:@selector(loginWithParse) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:parseButton];
}

-(void)loginWithParse
{
    self.parseController.delegate = self;
    [self.parseController loginUser];
}

-(void)loginSuccessful
{
    HomepageTVC *homepage = [[HomepageTVC alloc] init];
//    self.parseUser = user; // necessary?
//    self.parseUser = [PFUser currentUser];
//    homepage.parseUser = user;
    [homepage setLocationManager:self.locationManager];
    signedInUser = [[User alloc] initWithName:@"Meera"];
    homepage.signedInUser = signedInUser;
    
    [self.navigationController pushViewController:homepage animated:YES];

}

@end
