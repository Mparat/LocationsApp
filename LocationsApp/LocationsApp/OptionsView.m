//
//  OptionsView.m
//  LocationsApp
//
//  Created by Meera Parat on 6/24/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "OptionsView.h"
#import "MapVC.h"

@interface OptionsView ()

@end

@implementation OptionsView

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize me = _me;
@synthesize recipient = _recipient;
@synthesize signedInUser = _signedInUser;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initButtons];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    [self addNavBar];
}

-(void)addNavBar
{
    //
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initButtons
{
    UIButton *okay = [[UIButton alloc] initWithFrame:CGRectMake(4*self.view.frame.size.width/5, self.view.frame.size.height/10, 50, 50)];
    [okay setTitle:@"Okay" forState:UIControlStateNormal];
    [okay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okay addTarget:self action:@selector(sendOkay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okay];

    UIButton *tell = [[UIButton alloc] initWithFrame:CGRectMake(4*self.view.frame.size.width/5, 3*self.view.frame.size.height/10, 50, 50)];
    [tell setTitle:@"Tell" forState:UIControlStateNormal];
    [tell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tell addTarget:self action:@selector(tellLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tell];

    UIButton *ask = [[UIButton alloc] initWithFrame:CGRectMake(4*self.view.frame.size.width/5, 5*self.view.frame.size.height/10, 50, 50)];
    [ask setTitle:@"Ask" forState:UIControlStateNormal];
    [ask setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ask addTarget:self action:@selector(askLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ask];

    UIButton *text = [[UIButton alloc] initWithFrame:CGRectMake(4*self.view.frame.size.width/5, 7*self.view.frame.size.height/10, 50, 50)];
    [text setTitle:@"Text" forState:UIControlStateNormal];
    [text setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [text addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:text];

    UIButton *map = [[UIButton alloc] initWithFrame:CGRectMake(4*self.view.frame.size.width/5, 9*self.view.frame.size.height/10, 50, 50)];
    [map setTitle:@"Map" forState:UIControlStateNormal];
    [map setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [map addTarget:self action:@selector(viewMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:map];

}

-(void)sendOkay
{
    
}

-(void)tellLocation
{
    
}

-(void)askLocation
{
    
}

-(void)sendText
{
    NSString *number = self.recipient.phoneNumber;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", number]]];
}

-(void)viewMap
{
    MapVC *mapView = [[MapVC alloc] init];
    mapView.locationManager = self.locationManager;
    mapView.parseController = self.parseController;
    mapView.signedInUser = self.signedInUser;
    mapView.recipient = self.recipient;
    [self.navigationController pushViewController:mapView animated:YES];
}


@end
