//
//  MapVC.m
//  LocationsApp
//
//  Created by Meera Parat on 6/11/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "MapVC.h"
#import "MessageVC.h"
#import "OptionsView.h"

@interface MapVC ()

@end

@implementation MapVC // Map shows user + recipients at most recent location update and time of that update, hence, may not all be the same time, but it's watever time came with the location message object.

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize signedInUser = _signedInUser;
@synthesize me = _me;
@synthesize recipient = _recipient;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.view addSubview:[self.locationManager displayMap:self.view]];
    [self collectUniqueMessages];
    self.navigationController.navigationBarHidden = NO;

    [self addNavBar];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addNavBar
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@", self.recipient.firstName];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:239.0/255.0 green:61.0/255.0 blue:91.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}

-(void)collectUniqueMessages
{
    NSMutableArray *participants = [self.apiManager recipientUserIDs:self.conversation];
    NSOrderedSet *messages = [self.apiManager.layerClient messagesForConversation:self.conversation];
    NSMutableArray *array = [NSMutableArray array];
    [self findUniqueMessages:messages participants:participants count:[messages count]-1 array:array]; //array contains the last messagae from each user that isn't the client/user.me
    
    [self.view addSubview:[self.locationManager displayMap:self.view withAnnotations:[self.locationManager createAnnotationsFromMessages:array]]];
    
}


-(void)findUniqueMessages:(NSOrderedSet *)messages participants:(NSMutableArray *)participants count:(NSUInteger)index array:(NSMutableArray *)array
{
    if ([messages count] == 0) {
        return;
    }
    if ([participants count] == 0) {
        return;
    }
    for (NSString *userID in participants) {
        if ([((LYRMessage *)[messages objectAtIndex:index]).sentByUserID isEqualToString:userID]) {
            [array addObject:[messages objectAtIndex:index]];
            [participants removeObject:userID];
            [self findUniqueMessages:messages participants:participants count:index-- array:array];
        }

    }
//    return array;
}


@end
