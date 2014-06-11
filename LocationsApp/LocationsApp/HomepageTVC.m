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

@interface HomepageTVC ()

@property (nonatomic, strong) NSString *username;

@end

@implementation HomepageTVC

@synthesize signedInUser = _signedInUser;
@synthesize parseUser;
@synthesize username;
@synthesize locationManager = _locationManager;

@synthesize loggedIn;
#define chatCell @"chatCell"

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
    [self.tableView registerClass:[HomepageChatCell class] forCellReuseIdentifier:chatCell];
    [self addNavBar];
    parseUser = [PFUser currentUser];
    FBRequest *request = [FBRequest requestForMe];
//    NSLog(@"current user %@", [PFUser currentUser]);

    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSDictionary *userData = (NSDictionary *)result;
        
        NSString *facebookID = userData[@"id"];
        NSString *name = userData[@"name"];
        NSString *location = userData[@"location"][@"name"];
        NSString *gender = userData[@"gender"];
        NSString *birthday = userData[@"birthday"];
        NSString *relationship = userData[@"relationship_status"];
        
        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
        
        self.navigationItem.title = [NSString stringWithFormat:@"Hi, %@", name];
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
    [logout addTarget:self action:@selector(logoutUser) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithCustomView:logout];
    UIBarButtonItem *addFriendsButton = [[UIBarButtonItem alloc] initWithCustomView:findFriends];
    self.navigationItem.leftBarButtonItem = logoutButton;
    self.navigationItem.rightBarButtonItem = addFriendsButton;
//    self.navigationItem.title = [NSString stringWithFormat:@"Hi, %@", self.signedInUser.name];
}

-(void)logoutUser
{
    [PFUser logOut];
    parseUser = [PFUser currentUser];
    NSLog(@"user? %@", parseUser);
    Login *loginpage = [[Login alloc] init];
    loginpage.loggedIn = self.loggedIn;
    [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:loginpage] animated:TRUE completion:^{
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
//    self.searchBar.layer.cornerRadius = 10;
//    self.searchBar.layer.borderColor = [UIColor grayColor].CGColor;
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
    return 1;
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
    NSString *text = [self.locationManager fetchCurrentLocation].description;
    [cell placeSubviewsForCell:text];
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *text = [self.locationManager fetchCurrentLocation].description;
//    [(HomepageChatCell *)cell placeSubviewsForCell:text];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
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
