//
//  AddressBookTVC.m
//  LocationsApp
//
//  Created by Meera Parat on 6/17/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

/*
 at login, do the comparison and store the array of phone numbers in a nsuserdefault, code it, keyed archive, etc.....
*/


#import "AddressBookTVC.h"
#import <AddressBook/AddressBook.h>
#import "AppDelegate.h"
#import "AddContacts.h"
#import "HomepageTVC.h"
#import "SearchCell.h"
#import "Contact.h"
#import "ContactCell.h"
#import "SettingsTVC.h"

@interface AddressBookTVC () <UISearchDisplayDelegate, UISearchBarDelegate, MCSwipeTableViewCellDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation AddressBookTVC

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize signedInUser = _signedInUser;
@synthesize parseUserNumbers = _parseUserNumbers;
@synthesize parseUserUsernames = _parseUserUsernames;
@synthesize addressBook = _addressBook;
@synthesize contacts = _contacts;
@synthesize me = _me;
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
    [self addRecipientsView];
    [self getContacts];
    [self.tableView registerClass:[ContactCell class] forCellReuseIdentifier:contactCell];
    
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self addNavBar];

    selectedContacts = [NSMutableArray array];
    
//    [controller2 setTabBarItem:addNew];

    self.clearsSelectionOnViewWillAppear = NO;
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSData *data = [defaults objectForKey:self.me.username];
//    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    [self.me.messageRecipients addObjectsFromArray:array];
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
            for (int j = 0; j < ABMultiValueGetCount(phones); j++) {
                for (int k = 0; k < [self.parseUserNumbers count]; k++) {
                    NSString *number = [NSString stringWithFormat:@"1%@", (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j)];
                    NSCharacterSet *toExclude = [NSCharacterSet characterSetWithCharactersInString:@"/.()- "];
                    number = [[number componentsSeparatedByCharactersInSet:toExclude] componentsJoinedByString: @""];

                    if ([[self.parseUserNumbers objectAtIndex:k] isEqualToString:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, j)] || [[self.parseUserNumbers objectAtIndex:k] isEqualToString:number]) {
                        Contact *newContact = [[Contact alloc]init];
                        newContact.firstName = first;
                        newContact.lastName = last;
                        newContact.phoneNumber = [self.parseUserNumbers objectAtIndex:k];
                        newContact.username = [self.parseUserUsernames objectAtIndex:k];
                        [self.me.friends addObject:newContact];
                    }
                }
            }
        }
    }
}


-(void)addNavBar
{
    UIButton *settings = [[UIButton alloc] init];
    [settings setImage:[UIImage imageNamed:@"Settings"] forState:UIControlStateNormal];
    [settings addTarget:self action:@selector(toSettings) forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [settings setFrame:CGRectMake(-10, 0, 44, 44)];
    [view addSubview:settings];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = settingsButton;

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:239.0/255.0 green:61.0/255.0 blue:91.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    self.navigationItem.title = [NSString stringWithFormat:@"My Friends"];
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

#pragma mark - Search Bar Delegate controls
-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    UIButton *cancelButton;
    UIView *topView = self.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
        }
    }
    if (cancelButton) {
        [cancelButton setTitle:@"Done" forState:UIControlStateNormal];
    }
    
    // this is where to put the code to make sure the footer view is above the keyboard --> textfieldDidbeginediting, or something like that...
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterResults:searchString];
    return YES;
}

-(void)filterResults:(NSString *)searchTerm
{
    [self.searchResults removeAllObjects];
    [self.tableView reloadData];

    
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"firstName beginswith[cd] %@", searchTerm];
    NSMutableArray *filter1 = [NSMutableArray arrayWithArray:self.me.friends];
    [filter1 filterUsingPredicate:predicate1]; // filtered Names

    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"self beginswith[cd] %@", searchTerm];
    NSMutableArray *filter2 = [NSMutableArray arrayWithArray:self.parseUserUsernames];
    [filter2 filterUsingPredicate:predicate2]; // filtered usernames from Parse

    
    [self.searchResults addObjectsFromArray:filter1];
//    [self.searchResults addObjectsFromArray:filter2];
    
//    for (int i = 0; i < [filter2 count]; i++) {
//        for (int j = 0; j < [filter1 count]; j++) {
//            if
//        }
//    }
}

-(void)toSettings
{
    SettingsTVC *settings = [[SettingsTVC alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
}

-(void)addFriends
{
    AddContacts *add = [[AddContacts alloc] init];
    add.locationManager = self.locationManager;
    add.parseController = self.parseController;
    add.signedInUser = self.signedInUser;
    add.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:add] animated:NO completion:^{
        //
    }];
}

-(void)addRecipientsView
{
    footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 460, self.view.frame.size.width, 60);
    footer.backgroundColor = [UIColor colorWithRed:42.0/255.0 green:192.0/255.0 blue:124.0/255.0 alpha:1.0];
    send = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    send.frame = CGRectMake(257, 0, 58, 58);
    [send setBackgroundImage:[UIImage imageNamed:@"AskCell"] forState:UIControlStateNormal];
    [send addTarget:self action:@selector(askLocation) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:send];
    
    selectedContactsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 250, 20)];
    selectedContactsLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    selectedContactsLabel.textColor = [UIColor whiteColor];
    selectedContactsLabel.text = @"";
    [footer addSubview:selectedContactsLabel];
    
    UIButton *cancelSelection = [[UIButton alloc] initWithFrame:CGRectMake(6*self.navigationController.navigationBar.frame.size.width/10, 30, 70, 30)];
    [cancelSelection setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelSelection setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelSelection addTarget:self action:@selector(cancelSelection) forControlEvents:UIControlEventTouchUpInside];
    
    cancelSelectionButton = [[UIBarButtonItem alloc] initWithCustomView:cancelSelection];
}

-(void)askLocation
{
    [self.me.messageRecipients addObject:selectedContacts];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.me.messageRecipients];
    [defaults setObject:data forKey:self.me.username];
    [defaults synchronize];
    [self cancelSelection];
}

-(void)cancelSelection
{
    NSArray *paths = [NSArray arrayWithArray:[self.tableView indexPathsForSelectedRows]];
    int count = (int)[selectedContacts count];

    for (int i = 0; i < count; i++) {
        [self.tableView deselectRowAtIndexPath:[paths objectAtIndex:i] animated:NO];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[paths objectAtIndex:i]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setBackgroundColor: [UIColor whiteColor]];
        [selectedContacts removeObject:((ContactCell *)cell).contact];
    }
    [footer removeFromSuperview];
    self.navigationItem.rightBarButtonItem = nil;
    selectedContactsLabel.text = @"";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchController.searchResultsTableView){
        return [self.searchResults count];
    }
    else{
        return [self.me.friends count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:contactCell];
    cell = nil;
    if (cell == nil) {
        cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactCell];
    }
    
    [self configureCell:cell atIndexPath:indexPath inTableView:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


-(void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)path inTableView:(UITableView *)tableView
{
    Contact *friend = [[Contact alloc] init];
    if (tableView == self.searchController.searchResultsTableView){
        friend = [self.searchResults objectAtIndex:path.row];
    }
    else{
        friend = [self.me.friends objectAtIndex:path.row];
    }
    [(ContactCell *)cell initWithContact:friend];
    cell.contact = friend;
    [self configureSwipeViews:cell];
}

-(void)configureSwipeViews:(ContactCell *)cell
{
    UIView *askView = [self viewWithImageName:@"AskCell"];
    UIColor *greenColor = [UIColor colorWithRed:42.0 / 255.0 green:192.0 / 255.0 blue:124.0 / 255.0 alpha:1.0];
    
    UIView *tellView = [self viewWithImageName:@"TellCell"];
    UIColor *purpleColor = [UIColor colorWithRed:177.0 / 255.0 green:74.0 / 255.0 blue:223.0 / 255.0 alpha:1.0];

    
    [cell setSwipeGestureWithView:askView color:greenColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Ask\" cell");
        BOOL new = true;
        for (int i = 0; i < [self.me.messageRecipients count]; i++){
            if (![[self.me.messageRecipients objectAtIndex:i] isKindOfClass:[NSMutableArray class]]){
                if ([((ContactCell *)cell).contact.username isEqualToString:((Contact *)[self.me.messageRecipients objectAtIndex:i]).username]) {
                    NSLog(@"contact exits");
                    new = false;
                }
            }
        }
        if (new == true) {
            [self.me.messageRecipients addObject:((ContactCell *)cell).contact];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.me.messageRecipients];
            [defaults setObject:data forKey:self.me.username];
            [defaults synchronize];
        }
        if (new == false) {
            NSLog(@"Send a \"ask\" message");
        }
        ((ContactCell *)cell).contact.exists = YES;
        [cell swipeToOriginWithCompletion:^{
            //
        }];
    }];
    
    [cell setSwipeGestureWithView:tellView color:purpleColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"tell\" cell");
        BOOL new = true;
        for (int i = 0; i < [self.me.messageRecipients count]; i++){
            if (![[self.me.messageRecipients objectAtIndex:i] isKindOfClass:[NSMutableArray class]]){
                if ([((ContactCell *)cell).contact.username isEqualToString:((Contact *)[self.me.messageRecipients objectAtIndex:i]).username]) {
                    NSLog(@"contact exits");
                    new = false;
                }
            }
        }
        if (new == true) {
            [self.me.messageRecipients addObject:((ContactCell *)cell).contact];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.me.messageRecipients];
            [defaults setObject:data forKey:self.me.username];
            [defaults synchronize];
        }
        if (new == false) {
            NSLog(@"Send a \"tell\" message to an already created message recipient");
        }
        ((ContactCell *)cell).contact.exists = YES;
        [cell swipeToOriginWithCompletion:^{
            //
        }];
    }];
    
    cell.defaultColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
    cell.firstTrigger = 0.25;
//    cell.secondTrigger = 0.6;
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [cell setBackgroundColor: [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]];
        [selectedContacts addObject:((ContactCell *)cell).contact];
        if ([selectedContacts count] == 1) {
            selectedContactsLabel.text = [NSString stringWithFormat:@"%@ %@", selectedContactsLabel.text, ((Contact *)[selectedContacts lastObject]).firstName];
        }
        if ([selectedContacts count] > 1) {
            selectedContactsLabel.text = [NSString stringWithFormat:@"%@, %@", selectedContactsLabel.text, ((Contact *)[selectedContacts lastObject]).firstName];
        }
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [selectedContacts removeObject:((ContactCell *)cell).contact];
        [cell setBackgroundColor: [UIColor whiteColor]];
        selectedContactsLabel.text = @"";
        for (int i = 0; i < [selectedContacts count]; i++) {
            if (i == 0) {
                selectedContactsLabel.text = [NSString stringWithFormat:@"%@ %@", selectedContactsLabel.text, ((Contact *)[selectedContacts objectAtIndex:i]).firstName];
            }
            if (i > 0) {
                selectedContactsLabel.text = [NSString stringWithFormat:@"%@, %@", selectedContactsLabel.text, ((Contact *)[selectedContacts objectAtIndex:i]).firstName];
            }
        }
    }
    
//    NSIndexPath *path = [tableView indexPathForSelectedRow];
    if ([selectedContacts count] == 0) { // if (path)
        NSLog(@"no cell is selected");
        [footer removeFromSuperview];
        self.navigationItem.rightBarButtonItem = nil;
        selectedContactsLabel.text = @"";
    }
    else{
//        [self.view addSubview:footer];
        [self.navigationController.view addSubview:footer];
        self.navigationItem.rightBarButtonItem = cancelSelectionButton;
    }
}


@end
