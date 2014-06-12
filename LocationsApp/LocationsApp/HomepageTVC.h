//
//  HomepageTVC.h
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <Parse/Parse.h>
#import "LocationManagerController.h"

@interface HomepageTVC : UITableViewController <LocationManagerControllerDelegate>

@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) User *signedInUser;
@property (nonatomic, strong) PFUser *parseUser;
@property (nonatomic, strong) LocationManagerController *locationManager;

@property BOOL loggedIn;

@end
