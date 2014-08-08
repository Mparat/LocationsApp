//
//  LATabBarController.m
//  LocationsApp
//
//  Created by Meera Parat on 8/7/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "LATabBarController.h"
#import "Contact.h"
#import "HomepageTVC.h"
#import "AddressBookTVC.h"

@interface LATabBarController ()

@end

@implementation LATabBarController

@synthesize parseController = _parseController;
@synthesize locationManager = _locationManager;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadParseUsers
{
    self.parseController.signedInUser = [PFUser currentUser];
    PFQuery *query = [PFUser query];
    [query whereKeyExists:@"username"]; //email address --> use to send messages, use as user ID for app
    [query whereKey:@"username" notEqualTo:self.parseController.signedInUser.username];
    self.parseController.parseUsers = [NSMutableArray array];
   
    NSArray *users = [query findObjects];
    for (int i = 0; i < [users count]; i++) {
        NSString *username = [[users objectAtIndex:i] objectForKey:@"username"];
        NSString *firstName = [[users objectAtIndex:i] objectForKey:@"firstName"];
        NSString *lastName = [[users objectAtIndex:i] objectForKey:@"lastName"];
        NSString *userID = ((PFUser *)[users objectAtIndex:i]).objectId;
        Contact *person = [[Contact alloc] init];
        person.userID = userID;
        person.username = username;
        person.firstName = firstName;
        person.lastName = lastName;
        [self.parseController.parseUsers addObject:person];
    }
}

-(void)initViews
{
    User *me = [[User alloc] init];
    me.firstName = [self.parseController.signedInUser objectForKey:@"firstName"];
    me.lastName = [self.parseController.signedInUser objectForKey:@"lastName"];
    me.username = self.parseController.signedInUser.username; //email
    me.userID = self.parseController.signedInUser.objectId;
    
    NSUserDefaults *friends = [NSUserDefaults standardUserDefaults];
    NSData *data2 = [friends objectForKey:[NSString stringWithFormat:@"%@friends", me.username]];
    NSArray *array2 = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
    me.friends = [NSMutableArray arrayWithArray:array2];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:me.username];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    me.messageRecipients = [NSMutableArray arrayWithArray:array];
    
    HomepageTVC *homepage = [[HomepageTVC alloc] init];
    [homepage setLocationManager:self.locationManager];
    [homepage setParseController:self.parseController];
    homepage.signedInUser = self.parseController.signedInUser;
    homepage.apiManager = self.layerClientController.apiManager;
    homepage.me = me;
    UINavigationController *controller1 = [[UINavigationController alloc] initWithRootViewController:homepage];
    
    AddressBookTVC *contacts = [[AddressBookTVC alloc] init];
    contacts.locationManager = self.locationManager;
    contacts.parseController = self.parseController;
    contacts.signedInUser = self.parseController.signedInUser;
    contacts.apiManager = self.layerClientController.apiManager;
    contacts.me = me;
//    contacts.parseUsers = self.parseUsers;
    UINavigationController *controller2 = [[UINavigationController alloc] initWithRootViewController:contacts];
    
//    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    NSArray *controllers = [NSArray arrayWithObjects:controller1, controller2, nil];
    self.viewControllers = controllers;
    
    UIImage *unselectedContacts = [UIImage imageNamed:@"UnselectedContacts"];
    UIImage *selectedContacts = [UIImage imageNamed:@"SelectedContacts"];
    UIImage *unselectedMessages = [UIImage imageNamed:@"UnselectedMessages"];
    UIImage *selectedMessages = [UIImage imageNamed:@"SelectedMessages"];
    UIColor *red = [UIColor colorWithRed:239.0/255.0 green:61.0/255.0 blue:91.0/255.0 alpha:1.0];
    
    selectedMessages = [selectedMessages imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller1.tabBarController.tabBar.selectedImageTintColor = red;
    
    selectedContacts = [selectedContacts imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller2.tabBarController.tabBar.selectedImageTintColor = red;
    
    UITabBarItem *chats = [[UITabBarItem alloc] initWithTitle:@"Messages" image:unselectedMessages selectedImage:selectedMessages];
    UITabBarItem *addNew = [[UITabBarItem alloc] initWithTitle:@"Contacts" image:unselectedContacts selectedImage:selectedContacts];
    
    [controller1 setTabBarItem:chats];
    [controller2 setTabBarItem:addNew];
}


@end
