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
#import <Parse/Parse.h>

@interface Login ()

@property (nonatomic, strong) FBLoginView *fbLoginView;

@end


@implementation Login

@synthesize signedInUser;

@synthesize fbLoginView;

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
    [self addFBLoginButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)addNavBar
{
    self.navigationItem.title = @"Login";
}

-(void)addFBLoginButton
{
    fbLoginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"user_friends"]];
    fbLoginView.frame = CGRectMake((self.view.center.x - (fbLoginView.frame.size.width / 2)), self.view.frame.size.height/2, fbLoginView.frame.size.width, fbLoginView.frame.size.height);
    fbLoginView.delegate = self; // this allows me to call delegate methods on my FBLoginView reference
    [self.view addSubview:fbLoginView];
}

#pragma mark - FBLogin View Delegate methods

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"User is logged in");

}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"User info is now fetched");
    signedInUser = [[User alloc] init];
    signedInUser.name = [user first_name];
    HomepageTVC *homepage = [[HomepageTVC alloc] init];
    homepage.signedInUser = self.signedInUser;
    PFUser *currentUser = [PFUser currentUser];
    [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:homepage] animated:TRUE completion:^{
        //
    }];

}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"User is logged out");
}

@end
