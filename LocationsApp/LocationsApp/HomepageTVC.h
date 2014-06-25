//
//  HomepageTVC.h
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Contact.h"
#import <Parse/Parse.h>
#import "LocationManagerController.h"
#import "ParseController.h"
#import "MCSwipeTableViewCell.h"


@interface HomepageTVC : UITableViewController <UITextFieldDelegate, LocationManagerControllerDelegate, ParseControllerDelegate, UITableViewDataSource>

@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) ParseController *parseController;

@property (nonatomic, strong) PFUser *signedInUser;
@property (nonatomic, strong) PFUser *recipient;

@end