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

@implementation MapVC

@synthesize map = _map;
@synthesize locationManager = _locationManager;

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
    [self createMap];
    [self addNavBarButton];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createMap
{
    self.map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.map.showsUserLocation = YES;
    
    MKCoordinateRegion mapRegion; // structure that defines which map region to display
    CLLocation *location = [self.locationManager fetchCurrentLocation];
    mapRegion.center = location.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [self.map setRegion:mapRegion animated:YES];
    
    [self.view addSubview:self.map];
}

-(void) addNavBarButton
{
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [back setTitle:@"<" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToMessage) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:back];
//    self.navigationItem.leftBarButtonItem = backButton;

}

-(void)backToMessage
{
    MessageVC *message = [[MessageVC alloc] init];
    [message setLocationManager:self.locationManager];
    message.locationManager = self.locationManager;
    [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:message] animated:TRUE completion:^{
        //
    }];
}

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
