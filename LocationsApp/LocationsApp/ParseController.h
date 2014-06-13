//
//  ParseController.h
//  LocationsApp
//
//  Created by Meera Parat on 6/12/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"

@class ParseController;

@protocol ParseControllerDelegate <NSObject>

-(void) loginSuccessful;
-(void) logoutSuccessful;

@end

@interface ParseController : NSObject <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (nonatomic, weak) id<ParseControllerDelegate> delegate;
@property (nonatomic, strong) User *signedInUser;

@property (nonatomic,strong) PFLogInViewController *logInController;
@property (nonatomic, strong) PFLogInView *parseLoginView;

@property (nonatomic, strong) PFSignUpViewController *signUpController;
@property (nonatomic, strong) PFSignUpView *parseSignUpView;

@property (nonatomic, strong) PFUser *currentUser;

-(void)launchParse;
-(void)launchParseLogin:(UIView *)view;

-(void)FBloginUser;
-(void)FBlogoutUser;
-(void)FBRequestMyInfo;


@end
