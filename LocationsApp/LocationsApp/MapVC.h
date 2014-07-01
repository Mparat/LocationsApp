//
//  MapVC.h
//  LocationsApp
//
//  Created by Meera Parat on 6/11/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationManagerController.h"
#import "ParseController.h"
#import "User.h"
#import "Contact.h"

@interface MapVC : UIViewController 

@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) ParseController *parseController;
@property (nonatomic, strong) PFUser *signedInUser;

@property (nonatomic, strong) User *me;
@property (nonatomic, strong) Contact *recipient;

@end
