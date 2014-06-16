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
@synthesize signedInUser = _signedInUser;


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
//    [self addNavBarButton];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addNavBarButton
{
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [back setTitle:@"<" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToMessage) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backButton;

}

-(void)backToMessage
{
    MessageVC *message = [[MessageVC alloc] init];
    [message setLocationManager:self.locationManager];
    message.locationManager = self.locationManager;
    [self.navigationController pushViewController:message animated:YES];
}


@end
