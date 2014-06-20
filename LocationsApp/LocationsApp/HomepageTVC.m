//
//  HomepageTVC.m
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "HomepageTVC.h"
#import "HomepageChatCell.h"
#import "MessageVC.h"
#import "User.h"
#import "Login.h"
#import "FBFriendListTableViewController.h"
#import "LocationManagerController.h"
#import "Contact.h"
#import "AppDelegate.h"
#import "AddressBookTVC.h"
#import "AddContacts.h"
#import "MCSwipeTableViewCell.h"
#import "MapVC.h"

@interface HomepageTVC () <UISearchDisplayDelegate, UISearchBarDelegate, MCSwipeTableViewCellDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation HomepageTVC

@synthesize signedInUser = _signedInUser;
@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize recipient = _recipient;
//@synthesize swipeCell = _swipeCell;

@synthesize loggedIn;
#define chatCell @"chatCell"

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager.delegate = self;
    self.parseController.delegate = self;
    
    [self.tableView registerClass:[HomepageChatCell class] forCellReuseIdentifier:chatCell];
    [self addNavBar];
    [self addSearchBar];
    
    [[self.signedInUser objectForKey:@"friendsArray"] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)]; // friendsArray is an array of usernames, only
    [self.signedInUser save];
    
    self.navigationItem.title = [NSString stringWithFormat:@"Hi, %@", [self.signedInUser objectForKey:@"additional"]];
    
    [self.tableView reloadData];

//    FBRequest *request = [FBRequest requestForMe];
//    
//    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        //an <FBGraphUser> object representing the user's identity
//        NSDictionary *userData = (NSDictionary *)result;
//        
//        NSString *facebookID = userData[@"id"];
//        NSString *name = userData[@"name"];
//        NSString *firstName = userData[@"first_name"];
//        NSString *location = userData[@"location"][@"name"];
//        NSString *gender = userData[@"gender"];
//        NSString *birthday = userData[@"birthday"];
//        NSString *relationship = userData[@"relationship_status"];
//        
//        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
//        
//        self.signedInUser.name = name;
//        self.signedInUser.firstName = firstName;
//        self.signedInUser.picture = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
//        
//        self.navigationItem.title = [NSString stringWithFormat:@"Hi, %@", firstName];
//    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [[self.signedInUser objectForKey:@"friendsArray"] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [self.signedInUser save];
    
    [self.tableView reloadData];
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
    [logout setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logoutSuccessful) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithCustomView:logout];
    self.navigationItem.leftBarButtonItem = logoutButton;
}

-(void)addSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.tableView.tableHeaderView = self.searchBar;
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
//    CGPoint offset = CGPointMake(0, self.view.frame.size.height);
    CGPoint offset = CGPointMake(0, 30); // height offset is the height of the navigationBar --> decided from the logout button height.
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

    // I don't think you can create a new PFUser field that includes the friends' actual Names, because they are not unique so you wouldn't know what usernames they correspond with
    NSMutableArray *usernamesArray = [self.signedInUser objectForKey:@"friendsArray"]; //array with user's friends usernames (to search through) because these are all the people in the homepageTVC.
    NSMutableArray *namesArray = [[NSMutableArray alloc] init]; // array with the user's friends (usernames from friendsArray turned into PFusers)
    for (int i = 0; i < [usernamesArray count]; i++) {
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:[usernamesArray objectAtIndex:i]];
        PFUser *recipient = (PFUser *)[query getFirstObject];
        [namesArray addObject:[recipient objectForKey:@"additional"]]; // array of friends Names
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@", searchTerm];
//    [usernamesArray filterUsingPredicate:predicate]; // filtered usernames
    [namesArray filterUsingPredicate:predicate]; // filtered Names
    
//    NSMutableArray *friends1 = [[NSMutableArray alloc] init];
//    for (int i = 0; i < [usernamesArray count]; i++) {
//        PFQuery *query = [PFUser query];
//        [query whereKey:@"username" equalTo:[usernamesArray objectAtIndex:i]]; // filtered usernamesArray
//        PFUser *recipient = (PFUser *)[query getFirstObject];
//        [friends1 addObject:recipient]; // array of friends --> PFUsers
//    }
//    
    NSMutableArray *friends2 = [[NSMutableArray alloc] init];
    for (int i = 0; i < [namesArray count]; i++) {
        PFQuery *query = [PFUser query];
        [query whereKey:@"additional" equalTo:[namesArray objectAtIndex:i]]; // filtered NamesArray
        PFUser *recipient = (PFUser *)[query getFirstObject];
        [friends2 addObject:recipient]; // array of friends --> PFUsers
    }

//    if ([friends1 count] < [friends2 count]) {
//        [self.searchResults addObjectsFromArray:friends1];
//        for (int i = 0; i < [friends1 count]; i++) {
//            for (int j = 0; j < [friends2 count]; j++) {
//                if (![[[friends1 objectAtIndex:i] username] isEqualToString:[[friends2 objectAtIndex:j] username]]) {
//                    [self.searchResults addObject:[friends2 objectAtIndex:j]]; // add the extra from friends2 that don't overlap
//                }
//            }
//        }
//    }
//    else {
//        [self.searchResults addObjectsFromArray:friends2];
//        for (int i = 0; i < [friends1 count]; i++) {
//            for (int j = 0; j < [friends2 count]; j++) {
//                if (![[[friends1 objectAtIndex:i] username] isEqualToString:[[friends2 objectAtIndex:j] username]]) {
//                    [self.searchResults addObject:[friends1 objectAtIndex:i]]; // add the extra from friends1 that don't overlap
//                }
//            }
//        }
//    }
    
    // self.searchResults contains the PFUsers that match the searchTerm by username or Name
    

//    NSMutableArray *array = [self.signedInUser objectForKey:@"friendsArray"];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH[cd] %@", searchTerm];
//    [array filterUsingPredicate:predicate];
//    for (int i = 0; i < [array count]; i++) {
//        PFQuery *query = [PFUser query];
//        [query whereKey:@"username" equalTo:[array objectAtIndex:i]];
//        PFUser *recipient = (PFUser *)[query getFirstObject];
//        [self.searchResults addObject:recipient]; // array of friends Names
//    }

//    [self.searchResults addObjectsFromArray:[array filteredArrayUsingPredicate:predicate]];
    
//    [self.searchResults addObjectsFromArray:friends1];
    [self.searchResults addObjectsFromArray:friends2];
//
//    for (int i = 0; i < [friends1 count]; i++) {
//        for (int j = 0; j < [friends2 count]; j++) {
//            if ([[[friends1 objectAtIndex:i] objectForKey:@"username"] isEqualToString:[[friends2 objectAtIndex:j] objectForKey:@"username"]]) {
//                [self.searchResults removeObject:[friends1 objectAtIndex:i]];
//            }
//        }
//    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return [[self.signedInUser objectForKey:@"friendsArray"] count];
    }
    else{
        return [self.searchResults count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomepageChatCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCell];
    cell.delegate = self;
    cell = nil;
    if (cell == nil) {
        cell = [[HomepageChatCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:chatCell];
    }
    [self configureCell:cell atIndexPath:indexPath inTableView:tableView];
    return cell;
}

-(void)configureCell:(HomepageChatCell *)cell atIndexPath:(NSIndexPath *)path inTableView:(UITableView *)tableView
{
//    CLLocation *current = [self.locationManager fetchCurrentLocation];
//    NSString *text = [self.locationManager returnLocationName:current forIndexPath:path];
//    NSDate *date = current.timestamp;
    
    NSString *name = [[NSString alloc] init];
    if (tableView == self.tableView) {
        name = [[self.signedInUser objectForKey:@"friendsArray"] objectAtIndex:path.row]; // returns usernames (converted to Names when cell is created)
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:name];
        PFUser *recipient = (PFUser *)[query getFirstObject];
        name = [recipient objectForKey:@"additional"];
    }
    else{
        name = [[self.searchResults objectAtIndex:path.row] objectForKey:@"additional"];
    }
    
    // find the name corresponding to the username that is in the friendsArray
//    PFQuery *query = [PFUser query];
//    [query whereKey:@"username" equalTo:name];
//    PFUser *recipient = (PFUser *)[query getFirstObject];
//    NSString *actualName = [recipient objectForKey:@"additional"];
    
    [(HomepageChatCell *)cell placeSubviewsForCellWithName:name Location:@"location" Date:[NSDate dateWithTimeIntervalSinceNow:5]];
    [self configureSwipeViews:cell];

}

-(void)configureSwipeViews:(HomepageChatCell *)cell
{
    UILabel *askText = [[UILabel alloc] init];
    UIView *askView = [[UIView alloc] init];
    askText.text = @"Ask";
    askText.textColor = [UIColor blackColor];
    [askView addSubview:askText];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    
    UILabel *tellText = [[UILabel alloc] init];
    UIView *tellView = [[UIView alloc] init];
    tellText.text = @"Ask";
    tellText.textColor = [UIColor blackColor];
    [tellView addSubview:tellText];
    UIColor *yellowColor = [UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0];
    
    
    UILabel *mapText = [[UILabel alloc] init];
    UIView *mapView = [[UIView alloc] init];
    mapText.text = @"Ask";
    mapText.textColor = [UIColor blackColor];
    [mapView addSubview:mapText];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    //    UIColor *brownColor = [UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    
    [cell setSwipeGestureWithView:askView color:greenColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Ask\" cell");
        [cell swipeToOriginWithCompletion:^{
            //
        }];
    }];
    
    [cell setSwipeGestureWithView:tellView color:yellowColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState2 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"tell\" cell");
        [cell swipeToOriginWithCompletion:^{
            //
        }];
    }];
    
    [cell setSwipeGestureWithView:mapView color:redColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"map\" cell");
        MapVC *mapPage = [[MapVC alloc] init];
        mapPage.locationManager = self.locationManager;
        mapPage.parseController = self.parseController;
        mapPage.signedInUser = self.signedInUser;
        [self.navigationController pushViewController:mapPage animated:YES];
    }];
    
    [cell swipeToOriginWithCompletion:^{
        //
    }];
    cell.firstTrigger = 0.1;
    cell.secondTrigger = 0.6;    
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}


- (void) placemarkUpdated:(NSString *)location forIndexPath:(NSIndexPath *)path
{
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageVC *messageVC = [MessageVC alloc];
    messageVC.locationManager = self.locationManager;
    messageVC.parseController = self.parseController;
    messageVC.recipient = self.recipient;
    messageVC.signedInUser = self.signedInUser;
    messageVC = [messageVC init];
    [self.navigationController pushViewController:messageVC animated:YES];
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     // Return NO if you do not want the specified item to be editable.
     return YES;
 }



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete the row from the data source
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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



#pragma mark - MCSwipeTableViewCellDelegate

// Called when the user starts swiping the cell.
- (void)swipeTableViewCellDidStartSwiping:(MCSwipeTableViewCell *)cell{
    
}

// Called when the user ends swiping the cell.
- (void)swipeTableViewCellDidEndSwiping:(MCSwipeTableViewCell *)cell{
    
}

// Called during a swipe.
- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didSwipeWithPercentage:(CGFloat)percentage{
    
}



@end