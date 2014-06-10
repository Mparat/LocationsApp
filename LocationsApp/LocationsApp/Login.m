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

@interface Login ()

@property (nonatomic, strong) FBLoginView *fbLoginView;

@end


@implementation Login

@synthesize signedInUser;
@synthesize parseUser;
@synthesize fbLoginView;

@synthesize loggedIn;

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
//    [self addFBLoginButton];
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

-(void)addFBLoginButton
{
    fbLoginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"user_friends"]];
    fbLoginView.frame = CGRectMake((self.view.center.x - (fbLoginView.frame.size.width / 2)), self.view.frame.size.height/2, fbLoginView.frame.size.width, fbLoginView.frame.size.height);
    fbLoginView.delegate = self; // this allows me to call delegate methods on my FBLoginView reference

    [self.view addSubview:fbLoginView];
}

-(void)addLoginButon
{
    UIButton *parseButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 30, 300, 60, 30)];
    [parseButton setTitle:@"Login" forState:UIControlStateNormal];
    [parseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [parseButton addTarget:self action:@selector(parseLogin) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:parseButton];
}

-(void)parseLogin
{
//    if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
//        [PFFacebookUtils linkUser:[PFUser currentUser] permissions:nil block:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//                NSLog(@"current user %@", [PFUser currentUser]);
//                NSLog(@"Woohoo, user logged in with Facebook!");
//            }
//        }];
//    }
//    else{
//        NSLog(@"current user %@", [PFUser currentUser]);
//        NSLog(@"User is already linked with Facebook");
//    }

    [PFFacebookUtils logInWithPermissions:@[@"public_profile", @"user_friends"] block:^(PFUser *user, NSError *error) {
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
            HomepageTVC *homepage = [[HomepageTVC alloc] init];
            self.parseUser = user; // necessary?
            self.parseUser = [PFUser currentUser];
            homepage.parseUser = user;
//            if (![PFFacebookUtils isLinkedWithUser:user]) {
//                [PFFacebookUtils linkUser:user permissions:nil block:^(BOOL succeeded, NSError *error) {
//                    if (succeeded) {
//                        NSLog(@"current user %@", [PFUser currentUser]);
//                        NSLog(@"Woohoo, user logged in with Facebook!");
//                    }
//                }];
//            }
//            else{
//                NSLog(@"current user %@", [PFUser currentUser]);
//                NSLog(@"User is already linked with Facebook");
//            }
//            homepage.signedInUser = self.signedInUser;
            [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:homepage] animated:TRUE completion:^{
                //
            }];
        }
        NSLog(@"parseUser? %@", parseUser);
        NSLog(@"user? %@", user);
    }];
}

#pragma mark - FBLogin View Delegate methods

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"User is logged in");
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"User info is now fetched");

    if (loggedIn == NO) {
        self.parseUser = [PFUser user];
        self.parseUser.username = [user first_name];
        
        signedInUser = [[User alloc] init];
        signedInUser.name = [user first_name];
        HomepageTVC *homepage = [[HomepageTVC alloc] init];
        homepage.signedInUser = self.signedInUser;
        loggedIn = YES;
        [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:homepage] animated:TRUE completion:^{
//            [PFFacebookUtils logInWithPermissions:@[@"public_profile", @"user_friends"] block:^(PFUser *user, NSError *error) {
//                self.parseUser = user;
//            }];
        }];
    }
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"User is logged out");
    loggedIn = NO;
}

@end
