//
//  OptionsView.m
//  LocationsApp
//
//  Created by Meera Parat on 6/24/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "OptionsView.h"
#import "MapVC.h"
#import "MessageCVC.h"

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
//        self.view.alpha = 0.6;
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
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)initButtons
{
    UIButton *ask = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/2 - 105, 80, 80)];
    [[ask layer] setBorderColor:[UIColor blackColor].CGColor];
    [[ask layer] setBorderWidth:2.0f];
    [ask setTitle:@"Ask" forState:UIControlStateNormal];
    [ask setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ask addTarget:self action:@selector(askLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ask];

    UIButton *tell = [[UIButton alloc] initWithFrame:CGRectMake(120, self.view.frame.size.height/2 - 105, 80, 80)];
    [[tell layer] setBorderColor:[UIColor blackColor].CGColor];
    [[tell layer] setBorderWidth:2.0f];
    [tell setTitle:@"Tell" forState:UIControlStateNormal];
    [tell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tell addTarget:self action:@selector(tellLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tell];

    UIButton *okay = [[UIButton alloc] initWithFrame:CGRectMake(220, self.view.frame.size.height/2 - 105, 80, 80)];
    [[okay layer] setBorderColor:[UIColor blackColor].CGColor];
    [[okay layer] setBorderWidth:2.0f];
    [okay setTitle:@"Okay" forState:UIControlStateNormal];
    [okay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okay addTarget:self action:@selector(sendOkay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okay];
    
    UIButton *text = [[UIButton alloc] initWithFrame:CGRectMake(70, self.view.frame.size.height/2 + 25, 80, 80)];
    [[text layer] setBorderColor:[UIColor blackColor].CGColor];
    [[text layer] setBorderWidth:2.0f];
    [text setTitle:@"Text" forState:UIControlStateNormal];
    [text setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [text addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:text];

    UIButton *map = [[UIButton alloc] initWithFrame:CGRectMake(170, self.view.frame.size.height/2 + 25, 80, 80)];
    [[map layer] setBorderColor:[UIColor blackColor].CGColor];
    [[map layer] setBorderWidth:2.0f];
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
//    NSString *number = self.recipient.phoneNumber;
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", number]]];

    MessageCVC *message = [[MessageCVC alloc] init];
    message.locationManager = self.locationManager;
    message.parseController = self.parseController;
    message.signedInUser = self.signedInUser;
    message.recipient = self.recipient;
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:message] animated:YES completion:^{
        //
    }];
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


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touched, not on button");
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

@end
