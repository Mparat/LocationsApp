//
//  AddressBookTVC.m
//  LocationsApp
//
//  Created by Meera Parat on 6/17/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "AddressBookTVC.h"
#import "AppDelegate.h"
#import "AddContacts.h"
#import "HomepageTVC.h"
#import "SearchCell.h"
#import "Contact.h"
#import "ContactCell.h"

@interface AddressBookTVC () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation AddressBookTVC

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize signedInUser = _signedInUser;
@synthesize addressBook = _addressBook;
@synthesize contacts = _contacts;
@synthesize friends = _friends;

#define contactCell @"contactCell"
#define friendsArray @"friendsArray"

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavBar];
    [self addSearchBar];

    [self.tableView registerClass:[ContactCell class] forCellReuseIdentifier:contactCell];
    [self getContacts];
//    [[self.signedInUser objectForKey:@"friendsArray"] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//    [self.signedInUser save];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [[self.signedInUser objectForKey:@"friendsArray"] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [self.signedInUser save];
    
    UISwipeGestureRecognizer *swipeRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(addFriends)];
    [swipeRecognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [self.view addGestureRecognizer:swipeRecognizerLeft];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreate
}

-(void)getContacts
{
    CFErrorRef error;
    self.addressBook = ABAddressBookCreateWithOptions(NULL, &error);

    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                // Write your code here...
                // Fetch data from SQLite DB
            }
        });
        
        ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted) {
        ABRecordRef source = ABAddressBookCopyDefaultSource(self.addressBook);
        self.contacts = ABAddressBookCopyArrayOfAllPeopleInSource(self.addressBook, source);
        self.friends = [NSMutableArray array];
        
        for (int i = 0; i < CFArrayGetCount(self.contacts); i++) {
            ABRecordRef person = CFArrayGetValueAtIndex(self.contacts, i); // person
            NSString *first = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
            if (first == NULL) {
                first = @"";
            }
            NSString *last = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
            if (last == NULL) {
                last = @"";
            }
            ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(person, kABPersonPhoneProperty)); // list of phones
            NSString *phoneNumberLabel; // label of phone #
            for (CFIndex j = 0; j < ABMultiValueGetCount(phones); j++) {
                phoneNumberLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, j);
                PFQuery *query = [PFUser query];
                if ([phoneNumberLabel isEqualToString:kABPersonPhoneMobileLabel] || [phoneNumberLabel isEqualToString:kABPersonPhoneIPhoneLabel]) {
                    [query whereKeyExists:@"phoneNumber"];
                    [query whereKey:@"username" notEqualTo:self.signedInUser.username];
                    [query whereKey:@"phoneNumber" hasSuffix:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j)];
                    if (query != NULL) {
                        Contact *newContact = [[Contact alloc]init];
                        newContact.firstName = first;
                        newContact.lastName = last;
                        newContact.phoneNumber = [((PFUser *)query) objectForKey:@"phoneNumber"];
                        newContact.username = [((PFUser *)query) objectForKey:@"username"];
                        [self.friends addObject:newContact];
                    }
                }
            }
        }
    }
}

-(void)addNavBar
{
    UIButton *logout = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [logout setTitle:@"Logout" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logoutSuccessful) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithCustomView:logout];
    self.navigationItem.leftBarButtonItem = logoutButton;
    
    
    UIButton *findFriends = [[UIButton alloc] initWithFrame:CGRectMake(8*self.navigationController.navigationBar.frame.size.width/10, 10, 40, 30)];
    [findFriends setTitle:@"Add" forState:UIControlStateNormal];
    [findFriends setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [findFriends addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *addFriendsButton = [[UIBarButtonItem alloc] initWithCustomView:findFriends];
    self.navigationItem.rightBarButtonItem = addFriendsButton;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:210.0/255.0 green:75.0/255.0 blue:104.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    self.navigationItem.title = [NSString stringWithFormat:@"Contacts"];
}

-(void)addSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.tableView.tableHeaderView = self.searchBar;
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
    CGPoint offset = CGPointMake(0, self.view.frame.size.height);
    //CGPoint offset = CGPointMake(0, 30); // height offset is the height of the navigationBar --> decided from the logout button height.
    self.tableView.contentOffset = offset;
    self.searchResults = [NSMutableArray array];
}

-(void)logoutSuccessful
{
    [PFUser logOut];
    UINavigationController *controller = [(AppDelegate *) [[UIApplication sharedApplication] delegate] navigationController];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //
    }];
    [self.navigationController presentViewController:controller animated:YES completion:^{
        //
    }];
}

-(void)addFriends
{
    AddContacts *add = [[AddContacts alloc] init];
    add.locationManager = self.locationManager;
    add.parseController = self.parseController;
    add.signedInUser = self.signedInUser;
//    [self.navigationController pushViewController:add animated:NO];
    add.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:add] animated:NO completion:^{
        //
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [[self.signedInUser objectForKey:@"friendsArray"] count];
//    return CFArrayGetCount(self.contacts);
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:contactCell];
    cell = nil;
    if (cell == nil) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:contactCell];
    }
    
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}


-(void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)path
{
//    NSString *name = [[self.signedInUser objectForKey:@"friendsArray"] objectAtIndex:path.row];
    Contact *friend = [self.friends objectAtIndex:path.row];
    [(ContactCell *)cell initWithContact:friend];
    cell.contact = friend;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.signedInUser removeObject:((SearchCell *)cell).username forKey:@"friendsArray"];
        [self.signedInUser save];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



@end
