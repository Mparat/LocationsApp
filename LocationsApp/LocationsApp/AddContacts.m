//
//  AddContacts.m
//  LocationsApp
//
//  Created by Meera Parat on 6/16/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "AddContacts.h"
#import "SearchCell.h"
#import "HomepageTVC.h"
#import "AppDelegate.h"
#import "AddressBookTVC.h"

@interface AddContacts () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@interface AddContacts ()

@end

@implementation AddContacts

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize signedInUser = _signedInUser;
@synthesize className = _className;

#define searchCell @"searchCell"

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.parseClassName = @"_User";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavBar];
    [self.tableView setDelegate:self];
    
    [self.tableView reloadData];
    [self.tableView registerClass:[SearchCell class] forCellReuseIdentifier:searchCell];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.tableView.tableHeaderView = self.searchBar;
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
//    CGPoint offset = CGPointMake(0, self.view.frame.size.height);
//    self.tableView.contentOffset = offset;
    self.searchResults = [NSMutableArray array];
    
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    UISwipeGestureRecognizer *swipeRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toAddressBook)];
    [swipeRecognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self.view addGestureRecognizer:swipeRecognizerRight];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addNavBar
{
    UIButton *logout = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [logout setTitle:@"Logout" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logoutSuccessful) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithCustomView:logout];
//    self.navigationItem.leftBarButtonItem = logoutButton;

    self.navigationItem.title = [NSString stringWithFormat:@"Add Friends"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:210.0/255.0 green:75.0/255.0 blue:104.0/255.0 alpha:1.0];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:30]};
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

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

-(void)toAddressBook
{
    AddressBookTVC *addressBook = [[AddressBookTVC alloc] init];
    addressBook.locationManager = self.locationManager;
    addressBook.parseController = self.parseController;
    addressBook.signedInUser = self.parseController.signedInUser;
    [self.navigationController pushViewController:addressBook animated:NO];
}

-(void)filterResults:(NSString *)searchTerm
{
    [self.searchResults removeAllObjects];
    [self.tableView reloadData];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username BEGINSWITH[cd] %@", searchTerm];
//    PFQuery *query = [PFQuery queryWithClassName:@"_User" predicate:predicate];

    PFQuery *query = [PFUser query];
    [query whereKeyExists:@"username"]; // this is always goign to be true... so don't need to filter for this? All users will have a username and name
    [query whereKey:@"username" hasPrefix:searchTerm];
    [query whereKey:@"username" notEqualTo:self.signedInUser.username]; // don't include the signed In User in the search

    
    PFQuery *query2 = [PFUser query];
    [query2 whereKeyExists:@"additional"];
    [query2 whereKey:@"additional" hasPrefix:searchTerm];

    NSArray *results = [query findObjects];
    NSArray *results2 = [query2 findObjects];
    [self.searchResults addObjectsFromArray:results];
    [self.searchResults addObjectsFromArray:results2];
    
    for (int i = 0; i < [results count]; i++) {
        for (int j = 0; j < [results2 count]; j++) {
            if ([[[results objectAtIndex:i] objectForKey:@"username"] isEqualToString:[[results2 objectAtIndex:j] objectForKey:@"username"]]) {
                [self.searchResults removeObject:[results objectAtIndex:i]];
            }
        }
    }
}

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
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterResults:searchString];
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 1;
//    if (self.tableView == tableView) {
//        return 0;

    if ([self.searchResults count] == 0){
        return 0;
    }
    else
        return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
    cell = nil;
    if (cell == nil) {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:searchCell];
    }
    
//    [cell placeSubviewsForCell:[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"username"]];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(void)configureCell:(SearchCell *)cell atIndexPath:(NSIndexPath *)path
{
    // configure all  cells with Name
    NSString *name = [[self.searchResults objectAtIndex:path.row] objectForKey:@"additional"];
    [(SearchCell *)cell placeSubviewsForCell:name];
    NSArray *temp = [self.signedInUser objectForKey:@"friendsArray"];
    
    // check the current username result w/ all the usernames in your friendsArray
    // if the cell in question is a user that you are already friends with, then marked them w/ a checmark.
    for (int i = 0; i < [temp count]; i++) {
        NSString *searchUsername = [[self.searchResults objectAtIndex:path.row] username];
        NSString *friendUsername = [[self.signedInUser objectForKey:@"friendsArray"] objectAtIndex:i];
        if ([searchUsername isEqualToString:friendUsername]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.signedInUser addObject:[[self.searchResults objectAtIndex:indexPath.row] username] forKey:@"friendsArray"];
        [self.signedInUser save];
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.signedInUser removeObject:[[self.searchResults objectAtIndex:indexPath.row] username] forKey:@"friendsArray"];
        [self.signedInUser save];
    }
}



@end
