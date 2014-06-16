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

@interface HomepageTVC ()

@end

@implementation HomepageTVC

@synthesize signedInUser = _signedInUser;
@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize recipient = _recipient;


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
    
    self.navigationItem.title = [NSString stringWithFormat:@"Hi, %@", self.signedInUser.username];

    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        //an <FBGraphUser> object representing the user's identity
        NSDictionary *userData = (NSDictionary *)result;
        
        NSString *facebookID = userData[@"id"];
        NSString *name = userData[@"name"];
        NSString *firstName = userData[@"first_name"];
        NSString *location = userData[@"location"][@"name"];
        NSString *gender = userData[@"gender"];
        NSString *birthday = userData[@"birthday"];
        NSString *relationship = userData[@"relationship_status"];
        
        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
        
        //        self.signedInUser.name = name;
        //        self.signedInUser.firstName = firstName;
        //        self.signedInUser.picture = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
        
//        self.navigationItem.title = [NSString stringWithFormat:@"Hi, %@", firstName];
    }];
    
    FBRequest *friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSDictionary *myFriends = (NSDictionary *)result;
        NSArray *array = myFriends[@"data"];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addNavBar
{
    UIButton *findFriends = [[UIButton alloc] initWithFrame:CGRectMake(8*self.navigationController.navigationBar.frame.size.width/10, 10, 40, 30)];
    [findFriends setTitle:@"Add" forState:UIControlStateNormal];
    [findFriends setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [findFriends addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *logout = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [logout setTitle:@"Logout" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logoutSuccessful) forControlEvents:UIControlEventTouchUpInside];
    
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

-(void)addFriends
{
    return;
    //    FBFriendListTableViewController *fbFriendList = [[FBFriendListTableViewController alloc] init];
    //    [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:fbFriendList] animated:TRUE completion:^{
    //    }];
}

#pragma mark - Text field delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    header.backgroundColor = [UIColor whiteColor];
    self.searchBar = [[UITextField alloc] init];
    self.searchBar.placeholder = [NSString stringWithFormat:@"Search"];
    self.searchBar.frame = CGRectMake(0.5*header.frame.size.width/10, 5, 9*header.frame.size.width/10, 25);
    self.searchBar.borderStyle = UITextBorderStyleRoundedRect;
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.textAlignment = NSTextAlignmentNatural;
    
    self.searchBar.delegate = self;
    [header addSubview:self.searchBar];
    return header;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomepageChatCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCell];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configureCell:(HomepageChatCell *)cell atIndexPath:(NSIndexPath *)path
{
    CLLocation *current = [self.locationManager fetchCurrentLocation];
    NSString *text = [self.locationManager returnLocationName:current forIndexPath:path];
    NSDate *date = current.timestamp;
    [cell placeSubviewsForCellWithLocation:text Date:date];
    self.recipient = [[User alloc] init];
    self.recipient.name = cell.user.name;
}

- (void) placemarkUpdated:(NSString *)location forIndexPath:(NSIndexPath *)path
{
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageVC *messageVC = [MessageVC alloc];
    [messageVC setLocationManager:self.locationManager];
    messageVC.recipient = self.recipient;
    messageVC = [messageVC init];
    [self.navigationController pushViewController:messageVC animated:YES];
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