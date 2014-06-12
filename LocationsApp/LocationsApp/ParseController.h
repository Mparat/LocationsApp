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

@property (nonatomic,strong) PFLogInViewController *parseLoginController;
@property (nonatomic, weak) id<ParseControllerDelegate> delegate;

-(void)launchParse;
-(void)loginUser;

@end
