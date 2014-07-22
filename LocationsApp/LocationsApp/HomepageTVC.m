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
@synthesize newRow;

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
//    [self addSearchBar];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    newRow = false;
    [self.tableView reloadData];

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self addNavBar];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:self.me.username];
    if ([self.me.messageRecipients count] != 0) {
        self.me.messageRecipients = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    self.navigationController.navigationBarHidden = NO;
    if (self.tableView.editing) {
        [self setEditing:NO animated:NO];
    }
    [self.tableView reloadData];
    if (self.expandedIndexPath != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.expandedIndexPath]; //self.expandedIndexPath
        cell.layer.shadowColor = [[UIColor blackColor] CGColor];
        cell.layer.shadowOpacity = 0.1f;
        cell.layer.shadowOffset = CGSizeMake(0, 1);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addNavBar
{
    UIButton *settings = [[UIButton alloc] init];
    [settings setImage:[UIImage imageNamed:@"New"] forState:UIControlStateNormal];
    [settings addTarget:self action:@selector(createNewMessage) forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 58, 58)];
    [settings setFrame:CGRectMake(15, 0, 58, 58)];
    [view addSubview:settings];

    
    UIBarButtonItem *newMessageButton = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = newMessageButton;

    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.editButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"";

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:239.0/255.0 green:61.0/255.0 blue:91.0/255.0 alpha:1.0];
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
    if (tableView == self.searchController.searchResultsTableView) {
        return [self.searchResults count];
    }
    else{
        return [self.me.messageRecipients count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:section];
    if ([path compare:self.expandedIndexPath] == NSOrderedSame) {
        return [[self.me.messageRecipients objectAtIndex:path.section] count]+1;
    }
    else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
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
    CLLocation *current = [self.locationManager fetchCurrentLocation];
    NSString *text = [self.locationManager returnMyLocationName:current];
//    NSString *text = [self.locationManager returnLocationName:current forIndexPath:path];
//    NSDate *date = current.timestamp;
    
    Contact *recipient = [[Contact alloc] init];
    
    if ((self.expandedIndexPath != nil) && (path.section == self.expandedIndexPath.section) && (path.row != 0)) {
        Contact *recipient = [[Contact alloc] init];
        recipient = [[self.me.messageRecipients objectAtIndex:path.section] objectAtIndex:(path.row - 1)];
        ((HomepageChatCell *)cell).contact = recipient;
        [(HomepageChatCell *)cell placeSubviewsForCellWithName:recipient Location:nil Date:[NSDate date]];
        cell.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    }
    else{
        if (tableView == self.searchController.searchResultsTableView) {
            recipient = [self.searchResults objectAtIndex:path.section];
            cell.contact = recipient;
            [(HomepageChatCell *)cell placeSubviewsForCellWithName:recipient Location:@"location" Date:[NSDate date]];
        }
        else{
            if ([([self.me.messageRecipients objectAtIndex:path.section]) isKindOfClass:[NSMutableArray class]]) {
                [(HomepageChatCell *)cell placeSubviewsForGroupMessageCell:[self.me.messageRecipients objectAtIndex:path.section] Location:@"" Date:[NSDate date]]; //
                //            recipient = [[self.me.messageRecipients objectAtIndex:path.row] objectAtIndex:0];
                //            cell.contact = recipient;
            }
            else{
                recipient = [self.me.messageRecipients objectAtIndex:path.section];
                cell.contact = recipient;
                [(HomepageChatCell *)cell placeSubviewsForCellWithName:recipient Location:text Date:[NSDate date]]; // current date+time
            }
        }
    }

    [self configureSwipeViews:cell];
}

-(void)configureSwipeViews:(HomepageChatCell *)cell
{
    UIView *askView = [self viewWithImageName:@"AskCell"];
    UIColor *greenColor = [UIColor colorWithRed:42.0 / 255.0 green:192.0 / 255.0 blue:124.0 / 255.0 alpha:1.0];
    
    UIView *tellView = [self viewWithImageName:@"TellCell"];
    UIColor *purpleColor = [UIColor colorWithRed:177.0 / 255.0 green:74.0 / 255.0 blue:223.0 / 255.0 alpha:1.0];
    
    [cell setSwipeGestureWithView:askView color:greenColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Ask\" cell");
        [cell swipeToOriginWithCompletion:^{
            //
        }];
    }];
    
    [cell setSwipeGestureWithView:tellView color:purpleColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"tell\" cell");
        [cell swipeToOriginWithCompletion:^{
            //
        }];
    }];
    
    cell.defaultColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
    cell.firstTrigger = 0.25;
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
    [self.navigationController pushViewController:options animated:NO];
//    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:options] animated:YES completion:^{
//        //
//    }];
}


 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     // Return NO if you do not want the specified item to be editable.
     return YES;
 }

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    if (editing) {
        self.navigationController.editButtonItem.enabled = NO;
    } else {
        self.navigationController.editButtonItem.enabled = YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         [self.me.messageRecipients removeObjectAtIndex:indexPath.section];
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.me.messageRecipients];
         [defaults setObject:data forKey:self.me.username];
         [defaults synchronize];

         [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     } else if (editingStyle == UITableViewCellEditingStyleInsert) {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
 }

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
//        [tableView beginUpdates];
//        if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
//            self.expandedIndexPath = nil;
//            for (int i = 0; i < [[self.me.messageRecipients objectAtIndex:indexPath.section] count]; i++) {
//                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]]
//                                      withRowAnimation:UITableViewRowAnimationTop];
//                newRow = false;
//            }
//        }
//        [tableView endUpdates];
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates]; // triggers heightforrow..and rowsinsection
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        self.expandedIndexPath = nil;
        for (int i = 0; i < [[self.me.messageRecipients objectAtIndex:indexPath.section] count]; i++) {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]]
                                    withRowAnimation:UITableViewRowAnimationTop];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.layer.shadowColor = [[UIColor clearColor] CGColor];
            cell.layer.shadowOpacity = 0.0f;
            cell.layer.shadowOffset = CGSizeMake(0, 0);
            newRow = false;
        }
    }
    else{ //clicked to expand. triggers heightforrow..and rowsinsection
        if (self.expandedIndexPath != nil) {
            for (int i = 0; i < [[self.me.messageRecipients objectAtIndex:self.expandedIndexPath.section] count]; i++) {
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i+1 inSection:self.expandedIndexPath.section]]
                                      withRowAnimation:UITableViewRowAnimationTop];
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.expandedIndexPath];
                cell.layer.shadowColor = [[UIColor clearColor] CGColor];
                cell.layer.shadowOpacity = 0.0f;
                cell.layer.shadowOffset = CGSizeMake(0, 0);
                newRow = false;
            }
        }
        self.expandedIndexPath = indexPath;
        for (int i = 0; i < [[self.me.messageRecipients objectAtIndex:indexPath.section] count]; i++) {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.expandedIndexPath]; //indexPath
            cell.layer.shadowColor = [[UIColor blackColor] CGColor];
            cell.layer.shadowOpacity = 0.1f;
            cell.layer.shadowOffset = CGSizeMake(0, 1);
            
//            UITableViewCell *cell2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathWithIndex:indexPath.section+1]];
//            cell2.layer.shadowColor = [[UIColor blackColor] CGColor];
//            cell2.layer.shadowOpacity = 0.1f;
//            cell2.layer.shadowOffset = CGSizeMake(0, 1);

            newRow = true;
        }
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