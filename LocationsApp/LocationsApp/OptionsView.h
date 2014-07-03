//
//  OptionsView.h
//  LocationsApp
//
//  Created by Meera Parat on 6/24/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LocationManagerController.h"
#import "ParseController.h"
#import "Contact.h"
#import "User.h"

@interface OptionsView : UIViewController

@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) ParseController *parseController;

@property (nonatomic, strong) User *me;
@property (nonatomic, strong) Contact *recipient;

@property (nonatomic, strong) PFUser *signedInUser;

@end
