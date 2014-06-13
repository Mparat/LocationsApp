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

@interface MessageVC : UIViewController <UITableViewDelegate>
{
    UIButton *tellLocationButton;
    UIButton *ask;
    UIButton *send;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) User *recipient;
@property (nonatomic, strong) PFUser *signedInUser;

@end
