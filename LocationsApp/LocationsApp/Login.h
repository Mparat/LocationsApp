//
//  Login.h
//  LocationsApp
//
//  Created by Meera Parat on 6/9/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "LocationManagerController.h"
#import "ParseController.h"

@interface Login : UIViewController <ParseControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) ParseController *parseController;


@end