//
//  ContactsVC.h
//  LocationsApp
//
//  Created by Meera Parat on 6/26/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ContactsVC : UIViewController <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic,strong) ABPeoplePickerNavigationController *picker;

@end
