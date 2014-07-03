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
#import "LocationManagerController.h"
#import "Contact.h"
#import "AppDelegate.h"
#import "AddressBookTVC.h"
#import "AddContacts.h"
#import "MCSwipeTableViewCell.h"
#import "OptionsView.h"
#import "ContactCell.h"

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
@synthesize me = _me;
@synthesize expandedIndexPath = _expandedIndexPath;

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
    
    [self.tableView reloadData];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self addNavBar];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:self.me.username];
    self.me.messageRecipients = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addNavBar
{
    UIButton *new = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [new setTitle:@"New" forState:UIControlStateNormal];
    [new setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [new addTarget:self action:@selector(createNewMessage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *newMessageButton = [[UIBarButtonItem alloc] initWithCustomView:new];
    self.navigationItem.rightBarButtonItem = newMessageButton;

    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.title = [NSString stringWithFormat:@"Hi, %@", [self.signedInUser objectForKey:@"additional"]];

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:68.0/255.0 green:212.0/255.0 blue:103.0/255.0 alpha:1.0];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:10.0]};
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
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

-(void)createNewMessage
{
    [self.navigationController.tabBarController setSelectedIndex:1]; // to Contacts page
    // tab bar button for this page should be selected/highlighted
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

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName beginswith[cd] %@", searchTerm];
    NSMutableArray *filter = [NSMutableArray arrayWithArray:self.me.messageRecipients];
    [filter filterUsingPredicate:predicate]; // filtered Names
    
    [self.searchResults addObjectsFromArray:filter];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchController.searchResultsTableView) {
        return [self.searchResults count];
    }
    else{
        return [self.me.messageRecipients count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        return 250;
    }
    else{
        return 70;
    }
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
    
    Contact *recipient = [[Contact alloc] init];
    if (tableView == self.searchController.searchResultsTableView) {
        recipient = [self.searchResults objectAtIndex:path.row];
        cell.contact = recipient;
        [(HomepageChatCell *)cell placeSubviewsForCellWithName:recipient Location:@"location" Date:[NSDate date]];
    }
    else{
        if ([([self.me.messageRecipients objectAtIndex:path.row]) isKindOfClass:[NSMutableArray class]]) {
            [(HomepageChatCell *)cell placeSubviewsForGroupMessageCell:[self.me.messageRecipients objectAtIndex:path.row] Location:@"location" Date:[NSDate date]]; //
//            recipient = [[self.me.messageRecipients objectAtIndex:path.row] objectAtIndex:0];
//            cell.contact = recipient;
        }
        else{
            recipient = [self.me.messageRecipients objectAtIndex:path.row];
            cell.contact = recipient;
            [(HomepageChatCell *)cell placeSubviewsForCellWithName:recipient Location:@"location" Date:[NSDate date]]; // current date+time
        }
    }
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
    tellText.text = @"Tell";
    tellText.textColor = [UIColor blackColor];
    [tellView addSubview:tellText];
    UIColor *yellowColor = [UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0];
    
    [cell setSwipeGestureWithView:askView color:greenColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Ask\" cell");
        [cell swipeToOriginWithCompletion:^{
            //
        }];
    }];
    
    [cell setSwipeGestureWithView:tellView color:yellowColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"tell\" cell");
        [cell swipeToOriginWithCompletion:^{
            //
        }];
    }];
    
    cell.defaultColor = [UIColor grayColor];
    cell.firstTrigger = 0.2;
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.recipient = ((ContactCell *)cell).contact;
    OptionsView *options = [[OptionsView alloc] init];
    options.recipient = self.recipient;
    options.me = self.me;
    options.parseController = self.parseController;
    options.locationManager = self.locationManager;
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:options] animated:YES completion:^{
        //
    }];
}


 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     // Return NO if you do not want the specified item to be editable.
     return YES;
 }

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         [self.me.messageRecipients removeObjectAtIndex:indexPath.row];
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.me.messageRecipients];
         [defaults setObject:data forKey:self.me.username];
         [defaults synchronize];

         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     } else if (editingStyle == UITableViewCellEditingStyleInsert) {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
 }

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates]; // triggers heightforrow..
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        self.expandedIndexPath = nil;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [(HomepageChatCell *)cell clearViews];
        [(HomepageChatCell *)cell placeSubviewsForGroupMessageCell:[self.me.messageRecipients objectAtIndex:indexPath.row] Location:@"location" Date:[NSDate date]]; //
    }
    else{
        self.expandedIndexPath = indexPath;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [(HomepageChatCell *)cell clearViews];
        [(HomepageChatCell *)cell setGroupMessageCell:[self.me.messageRecipients objectAtIndex:indexPath.row] Location:@"location" Date:[NSDate date]];
    }
    [tableView endUpdates];
}


#pragma mark - MCSwipeTableViewCellDelegate // not being called..

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