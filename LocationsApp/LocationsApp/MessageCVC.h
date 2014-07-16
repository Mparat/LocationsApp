//
//  MessageCVC.h
//  LocationsApp
//
//  Created by Meera Parat on 7/2/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LocationManagerController.h"
#import "ParseController.h"
#import "User.h"
#import "Contact.h"


@interface MessageCVC : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>


@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) ParseController *parseController;
@property (nonatomic, strong) Contact *recipient;
@property (nonatomic, strong) PFUser *signedInUser;
@property (nonatomic, strong) User *me;

//- (id)init;

@end
