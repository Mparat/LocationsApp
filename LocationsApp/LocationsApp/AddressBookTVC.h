//
//  AddressBookTVC.h
//  LocationsApp
//
//  Created by Meera Parat on 6/17/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Parse/Parse.h>
#import "LocationManagerController.h"
#import "ParseController.h"


@interface AddressBookTVC : UITableViewController <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) ParseController *parseController;
@property (nonatomic, strong) PFUser *signedInUser;

@property (nonatomic) ABAddressBookRef addressBook;
@property (nonatomic) CFArrayRef contacts;

@property (nonatomic, strong) NSMutableArray *friends;


@end
