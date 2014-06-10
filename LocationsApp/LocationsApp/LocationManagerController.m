//
//  LocationManagerController.m
//  LocationsApp
//
//  Created by Meera Parat on 6/10/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "LocationManagerController.h"


@implementation LocationManagerController

@synthesize locationManager;
@synthesize locations = _locations;

#pragma mark - location manager delegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //Tells the delegate that new location data is available.
    
    //UIBackgroundMode required
    NSLog(@"Locations updated");
    self.locations = [[NSArray alloc] initWithArray:locations];
    // most recent location update is at the end of the locations array
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Updating locations failed with error: %@", error);
}


-(void)launchLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
//    [manager startUpdatingLocation];
    [self startUpdatingLocation];
}

-(void)startUpdatingLocation
{
    NSLog(@"Starting locations update");
    [locationManager startUpdatingLocation];
}

-(void)stopUpdatingLocation
{
    NSLog(@"Stopped updating location");
}

-(CLLocation *)fetchCurrentLocation
{
    NSLog(@"location: %@", [self.locations objectAtIndex:([self.locations count]-1)]);
    return [self.locations objectAtIndex:([self.locations count]-1)];
}


@end
