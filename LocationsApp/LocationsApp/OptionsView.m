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
#import "UIImage+ImageEffects.h"


@interface OptionsView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) UIImage *image;

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
//
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.image = [self capture];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 50)];
    [self updateImage];
    [self initButtons];
}

- (UIImage *) capture {
    UIGraphicsBeginImageContextWithOptions(self.parentViewController.view.bounds.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.parentViewController.view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(void)updateImage
{
    UIImage *effectImage = nil;
    effectImage = [self.image applyDarkEffect];
    self.imageView.image = effectImage;
    [self.view addSubview:self.imageView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:self action:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)initButtons
{
    UIButton *ask = [[UIButton alloc] initWithFrame:CGRectMake(21.5, 173, 78, 100)];
    [ask setBackgroundImage:[UIImage imageNamed:@"AskUnselected"] forState:UIControlStateNormal];
//    [tell setImage:[UIImage imageNamed:@"AskSelected"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [ask addTarget:self action:@selector(askLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ask];

    UIButton *tell = [[UIButton alloc] initWithFrame:CGRectMake(121, 173, 78, 100)];
    [tell setBackgroundImage:[UIImage imageNamed:@"TellSelected"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [tell setBackgroundImage:[UIImage imageNamed:@"TellUnselected"] forState:UIControlStateNormal];
//    [tell setImage:[UIImage imageNamed:@"TellSelected"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [tell addTarget:self action:@selector(tellLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tell];

    UIButton *text = [[UIButton alloc] initWithFrame:CGRectMake(220.5, 173, 78, 100)];
    [text setBackgroundImage:[UIImage imageNamed:@"TextUnselected"] forState:UIControlStateNormal];
//    [text setImage:[UIImage imageNamed:@"TextSelected"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [text addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:text];

    
    UIButton *directions = [[UIButton alloc] initWithFrame:CGRectMake(71.25, 295, 78, 100)];
    [directions setBackgroundImage:[UIImage imageNamed:@"DirectionsUnselected"] forState:UIControlStateNormal];
//    [directions setImage:[UIImage imageNamed:@"DirectionsSelected"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [directions addTarget:self action:@selector(toAppleMaps) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:directions];
    
    UIButton *map = [[UIButton alloc] initWithFrame:CGRectMake(170.75, 295, 78, 100)];
    [map setBackgroundImage:[UIImage imageNamed:@"MapUnselected"] forState:UIControlStateNormal];
//    [map setImage:[UIImage imageNamed:@"MapSelected"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [map addTarget:self action:@selector(viewMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:map];

    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(140, 450, 40, 40)];
    [close setBackgroundImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    //    [map setImage:[UIImage imageNamed:@"MapSelected"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [close addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
}

-(void)toAppleMaps
{
    NSURL *URL = [NSURL URLWithString:@"http://maps.apple.com/?q"];
    [[UIApplication sharedApplication] openURL:URL];
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
    
    MessageCVC *message = [[MessageCVC alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    message.locationManager = self.locationManager;
    message.parseController = self.parseController;
    message.signedInUser = self.signedInUser;
    message.recipient = self.recipient;
    [self.navigationController pushViewController:message animated:YES];

//    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:message] animated:YES completion:^{
//        //
//    }];
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

-(void)closeView
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:NO];
////    [self.navigationController dismissViewControllerAnimated:YES completion:^{
////        //
////    }];
//}


@end
