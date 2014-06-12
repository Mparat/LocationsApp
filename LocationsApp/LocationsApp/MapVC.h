//
//  MapVC.h
//  LocationsApp
//
//  Created by Meera Parat on 6/11/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationManagerController.h"

@interface MapVC : UIViewController

@property (nonatomic, strong) MKMapView *map;
@property (nonatomic, strong) LocationManagerController *locationManager;

@end
