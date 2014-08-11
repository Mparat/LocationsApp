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

@property (nonatomic, strong) NSArray *conversations;

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
    self.layerClient = self.apiManager.layerClient;

    [self.tableView registerClass:[HomepageChatCell class] forCellReuseIdentifier:chatCell];
    [self addNavBar];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    newRow = false;

    [self fetchLayerConversations];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey: self.me.username];
    if ([self.me.friends count] != 0) {
        self.me.friends = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self addNavBar];
    self.layerClient = self.apiManager.layerClient;
    [self fetchLayerConversations];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey: self.me.username];
    if ([self.me.friends count] != 0) {
        self.me.friends = [NSKeyedUnarchiver unarchiveObjectWithData:data];
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
        cell.layer.shadowOffset = CGSizeMake(0, 2);
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
    
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.editButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"";

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:239.0/255.0 green:61.0/255.0 blue:91.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

-(void)createNewMessage
{
    [self.navigationController.tabBarController setSelectedIndex:1]; // to Contacts page
}

-(void)updateFriends:(LYRConversation *)conversation completion:(void (^)(BOOL *, NSError *))completion
{
    NSParameterAssert(completion);
    NSSet *participants = conversation.participants;
    NSMutableArray *newFriends = [NSMutableArray array];
    for (NSString *uid in participants) {
        if ([self.me.friends count] == 0) {
            if (![uid isEqualToString:self.layerClient.authenticatedUserID]) {
                NSArray *new = [self.apiManager personFromConversation:conversation forUserID:uid];
                Contact *newFriend = [[Contact alloc] init];
                newFriend.userID = uid;
                newFriend.firstName = [new objectAtIndex:1];
                newFriend.lastName = [new objectAtIndex:2];
                [newFriends addObject:newFriend];
            }
        }
        else{
            NSMutableArray *ids = [NSMutableArray array];
            for (int i = 0; i < [self.me.friends count]; i++) {
                [ids addObject:((Contact *)[self.me.friends objectAtIndex:i]).userID];
            }
            if (![ids containsObject:uid] && ![uid isEqualToString:self.layerClient.authenticatedUserID]) {
                NSArray *new = [self.apiManager personFromConversation:conversation forUserID:uid];
                Contact *newFriend = [[Contact alloc] init];
                newFriend.userID = uid;
                newFriend.firstName = [new objectAtIndex:1];
                newFriend.lastName = [new objectAtIndex:2];
                [newFriends addObject:newFriend];
            }
        }
    }
    [self.me.friends addObjectsFromArray:newFriends];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.me.friends];
    [defaults setObject:data forKey: self.me.username];
    [defaults synchronize];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.conversations count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:section];
    if ([path compare:self.expandedIndexPath] == NSOrderedSame) {
        return [((LYRConversation *)[self.conversations objectAtIndex:path.section]).participants count];
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
        ((HomepageChatCell *)cell).locationManager = self.locationManager;
    }
    [self configureCell:cell atIndexPath:indexPath inTableView:tableView];
    return cell;
}


-(void)configureCell:(HomepageChatCell *)cell atIndexPath:(NSIndexPath *)path inTableView:(UITableView *)tableView
{
    LYRConversation *conversation = [self.conversations objectAtIndex:path.section];
    if ((self.expandedIndexPath != nil) && (path.section == self.expandedIndexPath.section) && (path.row != 0)) { //expanded cells, start at path.row index 1
        NSArray *person = [self.apiManager personFromConversation:conversation forUserID:[[self.apiManager recipientUserIDs:conversation] objectAtIndex:(path.row-1)]];
        [(HomepageChatCell *)cell createCellWith:conversation person:person layerClient:self.layerClient];
        cell.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    }
    else{
        if ([conversation.participants count] > 2) { //group message cell
            [(HomepageChatCell *)cell createGroupCellWithNames:[self.apiManager groupNameFromConversation:conversation] conversation:conversation layerClient:self.layerClient];
            [self downArrow:cell];
        }
        else{ //single person cell
            NSArray *person = [self.apiManager personFromConversation:conversation forUserID:[[self.apiManager recipientUserIDs:conversation] objectAtIndex:0]];
            [(HomepageChatCell *)cell createCellWith:conversation person:person layerClient:self.layerClient];
        }
    }
    [self editCellCircle:cell];
    [self configureSwipeViews:cell];
}


- (void)accessoryButtonTapped:(id)sender event:(id)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil){
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
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
            NSMutableDictionary *convoContacts = [self.apiManager returnParticipantDictionary:((HomepageChatCell *)cell).conversation];
            [self.apiManager sendAskMessageToRecipients:convoContacts];
            [self editCellCircle:cell];
            [self.tableView reloadData];
        }];
    }];
    
    [cell setSwipeGestureWithView:tellView color:purpleColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"tell\" cell");
        [cell swipeToOriginWithCompletion:^{
            NSMutableDictionary *convoContacts = [self.apiManager returnParticipantDictionary:((HomepageChatCell *)cell).conversation];
            [self.apiManager sendTellMessageToRecipients:convoContacts];
            [self editCellCircle:cell];
            [self.tableView reloadData];
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

- (void) placemarkUpdated:(NSString *)location forIndexPath:(NSIndexPath *)path
{
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    OptionsView *options = [[OptionsView alloc] init];
    options.me = self.me;
    options.apiManager = self.apiManager;
    options.parseController = self.parseController;
    options.locationManager = self.locationManager;
    options.conversation = [self.conversations objectAtIndex:indexPath.row];
    options.message = ((HomepageChatCell *)cell).message;
    options.theirLastMessages = ((HomepageChatCell *)cell).theirLastMessages;
    [self.navigationController pushViewController:options animated:NO];
//    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:options] animated:YES completion:^{
//        //
//    }];
}


 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     return YES;
 }

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    if (editing) {
        self.navigationController.editButtonItem.enabled = NO;
        for (UITableViewCell *cell in self.tableView.visibleCells) { // loop through the visible cells and animate their imageViews
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.contentView.frame = CGRectMake(30, cell.contentView.frame.origin.y, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
            } completion:^(BOOL finished) {
                cell.contentView.frame = CGRectMake(30, cell.contentView.frame.origin.y, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
            }];
        }
    } else {
        self.navigationController.editButtonItem.enabled = YES;
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates]; // clicked to close //triggers heightforrow..and rowsinsection
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        self.expandedIndexPath = nil;
        for (int i = 0; i < [((LYRConversation *)[self.conversations objectAtIndex:indexPath.section]).participants count]-1; i++) {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]]
                                    withRowAnimation:UITableViewRowAnimationTop];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.layer.shadowColor = [[UIColor clearColor] CGColor];
            cell.layer.shadowOpacity = 0.0f;
            cell.layer.shadowOffset = CGSizeMake(0, 0);
            [self downArrow:cell];
            newRow = false;
        }
    }
    else{ //clicked to expand. triggers heightforrow..and rowsinsection
        if (self.expandedIndexPath != nil) {
            for (int i = 0; i < [((LYRConversation *)[self.conversations objectAtIndex:self.expandedIndexPath.section]).participants count]-1; i++) {
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i+1 inSection:self.expandedIndexPath.section]]
                                      withRowAnimation:UITableViewRowAnimationTop];
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.expandedIndexPath];
                cell.layer.shadowColor = [[UIColor clearColor] CGColor];
                cell.layer.shadowOpacity = 0.0f;
                cell.layer.shadowOffset = CGSizeMake(0, 0);
                [self downArrow:cell];

                newRow = false;
            }
        }
        self.expandedIndexPath = indexPath;
        for (int i = 0; i < [((LYRConversation *)[self.conversations objectAtIndex:indexPath.section]).participants count]-1; i++) {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i+1 inSection:indexPath.section]]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.expandedIndexPath]; //indexPath
            cell.layer.shadowColor = [[UIColor blackColor] CGColor];
            cell.layer.shadowOpacity = 0.1f;
            cell.layer.shadowOffset = CGSizeMake(0, 1);
            [self upArrow:cell];
//            UITableViewCell *cell2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathWithIndex:indexPath.section+1]];
//            cell2.layer.shadowColor = [[UIColor blackColor] CGColor];
//            cell2.layer.shadowOpacity = 0.1f;
//            cell2.layer.shadowOffset = CGSizeMake(0, 1);

            newRow = true;
        }
    }
    [tableView endUpdates];
}

-(void)editCellCircle:(UITableViewCell *)cell
{
    if (![((HomepageChatCell *)cell).message.sentByUserID isEqual:self.layerClient.authenticatedUserID]) {
        UIImageView *unread = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UnreadCircle"]];
        unread.frame = CGRectMake(15, 19.5, 29, 29);
        [cell addSubview:unread];
    }
    else {
        UIImageView *read = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReadCircle"]];
        read.frame = CGRectMake(15, 19.5, 29, 29);
        [cell addSubview:read];
    }
}


-(void)downArrow:(UITableViewCell *)cell
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 29, 29)];
    [button setImage:[UIImage imageNamed:@"DownArrow"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(accessoryButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = button;
}

-(void)upArrow:(UITableViewCell *)cell
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 29, 29)];
    [button setImage:[UIImage imageNamed:@"UpArrow"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(accessoryButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = button;
}


-(void)fetchLayerConversations
{
    if (self.conversations) {
        self.conversations = nil;
    }
    NSSet *convos = (NSSet *)[self.layerClient conversationsForIdentifiers:nil];
    self.conversations = [[convos allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastMessage.sentAt" ascending:NO]]];
    for (LYRConversation *conversation in self.conversations) {
        [self updateFriends:conversation completion:^(BOOL *done, NSError *error) {
            //
        }];
    }
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