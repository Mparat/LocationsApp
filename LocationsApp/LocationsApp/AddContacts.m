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
@synthesize addedFriends = _addedFriends;

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
//    [self.tableView addSubview:self.searchBar];
    self.tableView.tableHeaderView = self.searchBar;
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
    CGPoint offset = CGPointMake(0, self.view.frame.size.height);
    self.tableView.contentOffset = offset;
    self.searchResults = [NSMutableArray array];
    
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    self.addedFriends = [[NSMutableArray alloc] init];
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

    UIButton *findFriends = [[UIButton alloc] initWithFrame:CGRectMake(8*self.navigationController.navigationBar.frame.size.width/10, 10, 40, 30)];
    [findFriends setTitle:@"Add" forState:UIControlStateNormal];
    [findFriends setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [findFriends addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithCustomView:logout];
    UIBarButtonItem *addFriendsButton = [[UIBarButtonItem alloc] initWithCustomView:findFriends];
   
    self.navigationItem.leftBarButtonItem = logoutButton;
    self.navigationItem.rightBarButtonItem = addFriendsButton;
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

-(void)add
{
    [[self.signedInUser objectForKey:@"friends"] arrayByAddingObjectsFromArray:self.addedFriends];
}

-(void)filterResults:(NSString *)searchTerm
{
//    if ([searchTerm  isEqual: @""]) {
//        [self.searchResults removeAllObjects];
//    }
    [self.searchResults removeAllObjects];
    [self.tableView reloadData];
    PFQuery *query = [PFUser query];
    [query whereKeyExists:@"username"];
    [query whereKey:@"username" containsString:searchTerm];

    NSArray *results = [query findObjects];

    NSLog(@"%@", results);
    NSLog(@"%lu",(unsigned long)[results count]);
    
    [self.searchResults addObjectsFromArray:results];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterResults:searchString];
    return YES;
}


-(void)toHomepage
{
    HomepageTVC *home = [[HomepageTVC alloc] init];
    home.locationManager = self.locationManager;
    home.parseController = self.parseController;
    home.signedInUser = self.signedInUser;
    [self.navigationController pushViewController:home animated:NO];
}

-(void)addFriends
{
    AddContacts *add = [[AddContacts alloc] init];
    add.locationManager = self.locationManager;
    add.parseController = self.parseController;
    add.signedInUser = self.signedInUser;
    [self.navigationController pushViewController:add animated:NO];
}

#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor grayColor];
    
    UIButton *chatView = [[UIButton alloc] initWithFrame:CGRectMake(1*self.tableView.frame.size.width/5, 10, 100, 50)];
    [chatView setTitle:@"Messages" forState:UIControlStateNormal];
    [chatView setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [chatView addTarget:self action:@selector(toHomepage) forControlEvents:UIControlEventTouchUpInside];
    footer.userInteractionEnabled = YES;
    
    [footer addSubview:chatView];
    
    UIButton *addContacts = [[UIButton alloc] initWithFrame:CGRectMake(3*self.tableView.frame.size.width/5, 10, 100, 50)];
    [addContacts setTitle:@"Add" forState:UIControlStateNormal];
    [addContacts setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [addContacts addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    footer.userInteractionEnabled = YES;
    
    [footer addSubview:addContacts];
    return footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 70;
}


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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCell];
    cell = nil;
    if (cell == nil) {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:searchCell];
    }
    
    [cell placeSubviewsForCell:[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"username"]];
    
    return cell;
}

-(void)configureCell:(SearchCell *)cell atIndexPath:(NSIndexPath *)path
{
    [(SearchCell *)cell placeSubviewsForCell:[[self.searchResults objectAtIndex:path.row] objectForKey:@"username"]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.addedFriends addObject:((SearchCell *)cell).username];
        self.signedInUser = [PFUser currentUser];
//        self.signedInUser[@"friend"] = ((SearchCell *)cell).username;
        [self.signedInUser addObjectsFromArray:self.addedFriends forKey:@"friendsArray"];
//        self.signedInUser[@"friendArray"] = self.addedFriends;
        [self.signedInUser save];
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.addedFriends removeObject:cell];
    }
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
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
 */

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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
*/

@end
