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
@synthesize current;
@synthesize geocoder;
@synthesize placemark;

@synthesize mapViewController;


#pragma mark - location manager delegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //Tells the delegate that new location data is available.
    //UIBackgroundMode required
    NSLog(@"Locations updated");
    self.locations = [[NSArray alloc] initWithArray:locations];
    current = [self fetchCurrentLocation];
//    if ([self.locations count] == 1){
//        [self stopCollectingLocations];
//    }
    
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
    [self startCollectingLocations];
    
    mapViewController = [[MKMapView alloc] init];
    [mapViewController setDelegate:self];

}

-(void)startCollectingLocations
{
    NSLog(@"Starting locations update");
    [locationManager startUpdatingLocation];
//    [self stopCollectingLocations];

}

-(void)stopCollectingLocations
{
    NSLog(@"Stopped updating location");
    [locationManager stopUpdatingLocation];
}

-(CLLocation *)fetchCurrentLocation
{
    return (CLLocation *)[self.locations objectAtIndex:([self.locations count]-1)];
}

-(NSString *)returnLocationName:(CLLocation *)location
{
    if (!geocoder) {
        geocoder = [[CLGeocoder alloc] init];
    }
    NSLog(@"%d", kCLErrorGeocodeFoundNoResult);
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            placemark = [placemarks lastObject];
        }
    }];
    NSLog(@"placemark? %@", placemark);
    return placemark.name;
}

-(NSString *)returnName:(CLPlacemark *)temp
{
    return temp.name;
}

#pragma mark - MKMapView delegate methods

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    MKCoordinateRegion mapRegion; // structure that defines which map region to display
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [mapView setRegion:mapRegion animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    return nil;
}


@end
