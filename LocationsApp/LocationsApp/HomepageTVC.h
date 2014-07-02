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
#import "User.h"


@interface HomepageTVC : UITableViewController <UITextFieldDelegate, LocationManagerControllerDelegate, ParseControllerDelegate, UITableViewDataSource>
{
    int number;
}

@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) ParseController *parseController;

@property (nonatomic, strong) PFUser *signedInUser;

@property (nonatomic, strong) User *me;
@property (nonatomic, strong) Contact *recipient;

@property (nonatomic, strong) NSIndexPath *expandedIndexPath;

@end