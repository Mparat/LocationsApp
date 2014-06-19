//
//  SwipedCellController.m
//  LocationsApp
//
//  Created by Meera Parat on 6/18/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "SwipedCellController.h"
#import "MapVC.h"

@interface SwipedCellController ()

@end

@implementation SwipedCellController

@synthesize signedInUser = _signedInUser;
@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toMap
{
    MapVC *mapView = [[MapVC alloc] init];
    mapView.locationManager = self.locationManager;
    mapView.parseController = self.parseController;
    mapView.signedInUser = self.signedInUser;
    [self.navigationController pushViewController:mapView animated:YES];
}




@end
