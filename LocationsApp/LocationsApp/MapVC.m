//
//  MapVC.m
//  LocationsApp
//
//  Created by Meera Parat on 6/11/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "MapVC.h"
#import "MessageVC.h"

@interface MapVC ()

@end

@implementation MapVC // Map shows user + recipients at most recent location update and time of that update, hence, may not all be the same time, but it's watever time came with the location message object.

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize signedInUser = _signedInUser;
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
    [self.view addSubview:[self.locationManager displayMap:self.view]];
    [self addNavBar];

    UITableViewController *extra = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    extra.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    extra.tableView.backgroundColor = [UIColor blackColor];
    extra.tableView.alpha = 0.6;
    
//    extra.navigationController.navigationBar.opaque = YES;
//    extra.navigationController.navigationBar.translucent = YES;
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
//    extra.navigationController.navigationBar.barTintColor = [UIColor clearColor];
//    extra.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:extra.tableView];

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
//    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
//    [back setTitle:@"<" forState:UIControlStateNormal];
//    [back setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [back addTarget:self action:@selector(backToMessage) forControlEvents:UIControlEventTouchUpInside];
//
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:back];
//    self.navigationItem.leftBarButtonItem = backButton;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@", [self.recipient objectForKey:@"additional"]];

//    self.navigationController.navigationBar.opaque = YES;
//    self.navigationController.navigationBar.translucent = YES;
////    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
//    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:205.0/255.0 blue:6.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

}

-(void)backToMessage
{
    MessageVC *message = [[MessageVC alloc] init];
    [message setLocationManager:self.locationManager];
    message.locationManager = self.locationManager;
    [self.navigationController pushViewController:message animated:YES];
}


@end
