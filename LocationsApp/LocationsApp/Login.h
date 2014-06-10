//
//  Login.h
//  LocationsApp
//
//  Created by Meera Parat on 6/9/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "User.h"
#import <Parse/Parse.h>

@interface Login : UIViewController <FBLoginViewDelegate>

@property (nonatomic, strong) User *signedInUser;
@property (nonatomic, strong) NSString *loginOrOut;
@property (nonatomic, strong) PFUser *parseUser;

@property BOOL loggedIn;

@end
