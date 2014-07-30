//
//  AddContacts.h
//  LocationsApp
//
//  Created by Meera Parat on 6/16/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LocationManagerController.h"
#import "ParseController.h"

@interface AddContacts : PFQueryTableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) ParseController *parseController;
@property (nonatomic, strong) PFUser *signedInUser;
@property (nonatomic, strong) User *me;

@property (nonatomic, strong) NSMutableArray *parseUsernames;
@property (nonatomic, strong) NSMutableArray *parseFirstNames;
@property (nonatomic, strong) NSMutableArray *parseLastNames;

@property (nonatomic, strong) NSMutableArray *parseUsers;

@property (nonatomic, strong) NSString *className;


@end
