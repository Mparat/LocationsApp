//
//  MessageVC.h
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LocationManagerController.h"
#import "User.h"
#import "Contact.h"
#import "ParseController.h"

@interface MessageVC : UIViewController <UITableViewDelegate, UITextFieldDelegate>
{
    UIButton *tellLocationButton;
    UIButton *ask;
    UIButton *send;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) ParseController *parseController;
@property (nonatomic, strong) Contact *recipient;
@property (nonatomic, strong) PFUser *signedInUser;
@property (nonatomic, strong) User *user;

@end
