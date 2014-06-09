//
//  Login.m
//  LocationsApp
//
//  Created by Meera Parat on 6/9/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "Login.h"
#import <FacebookSDK/FacebookSDK.h>

@interface Login ()

@property (nonatomic, strong) FBLoginView *fbLoginView;

@end


@implementation Login

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addNavBar
{
    UIView *title = [[UIView alloc] initWithFrame:CGRectMake(100, 10, 100, 30)];
    UILabel *text = [[UILabel alloc] init];
    [text setText:@"Login"];
    [title addSubview:text];
    self.navigationItem.titleView = title;
}

-(void)addFBLoginButton
{
    fbLoginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"user_friends"]];
    fbLoginView.frame = CGRectMake((self.view.center.x - (fbLoginView.frame.size.width / 2)), self.view.frame.size.height/2, fbLoginView.frame.size.width, fbLoginView.frame.size.height);
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
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"User is logged out");
}

@end
