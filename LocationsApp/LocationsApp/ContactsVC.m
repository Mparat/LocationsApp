//
//  ContactsVC.m
//  LocationsApp
//
//  Created by Meera Parat on 6/26/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "ContactsVC.h"

@interface ContactsVC ()

@end

@implementation ContactsVC

@synthesize picker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showPicker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showPicker
{
    picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    picker.displayedProperties = [NSArray arrayWithObject:kABPersonPhoneMainLabel];
    [self presentViewController:picker animated:YES completion:^{
        //
    }];
}


#pragma APPeoplePickerNavigationController Delegate Methods

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:picker completion:^{
        //
    }];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return NO;
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}


@end
