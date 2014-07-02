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
    [self.view addSubview:[self.locationManager displayMap:self.view]];
    self.navigationController.navigationBarHidden = NO;

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
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [done addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithCustomView:done];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@", self.recipient.firstName];
                                

//    self.navigationController.navigationBar.opaque = YES;
//    self.navigationController.navigationBar.translucent = YES;
////    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
//    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:205.0/255.0 blue:6.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

}

-(void)done
{
    OptionsView *options = [[OptionsView alloc] init];
    [self.navigationController pushViewController:options animated:YES];
}


@end
