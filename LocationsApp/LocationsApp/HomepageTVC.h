//
//  HomepageTVC.h
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface HomepageTVC : UITableViewController

@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) User *signedInUser;

@end
