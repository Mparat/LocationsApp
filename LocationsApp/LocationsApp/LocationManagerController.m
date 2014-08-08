//
//  LocationManagerController.m
//  LocationsApp
//
//  Created by Meera Parat on 6/10/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "LocationManagerController.h"
#import "MapViewAnnotation.h"


@implementation LocationManagerController

@synthesize locationManager;
@synthesize locations = _locations;
@synthesize current = _current;
@synthesize geocoder = _geocoder;
@synthesize placemark = _placemark;

@synthesize map = _map;


-(void)launchLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:100.f];
    [self startCollectingLocations];
}

-(void)startCollectingLocations
{
    NSLog(@"Starting locations update");
    [locationManager startUpdatingLocation];
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusAvailable) {
        
        NSLog(@"Background updates are available for the app.");
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied)
    {
        NSLog(@"The user explicitly disabled background behavior for this app or for the whole system.");
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted)
    {
        NSLog(@"Background updates are unavailable and the user cannot enable them again. For example, this status can occur when parental controls are in effect for the current user.");
    }
}

-(void)stopCollectingLocations
{
    NSLog(@"Stopped updating location");
    [locationManager stopUpdatingLocation];
}

#pragma mark - location manager delegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //Tells the delegate that new location data is available.
    //UIBackgroundMode required
    NSLog(@"Locations updated");
    self.locations = [[NSArray alloc] initWithArray:locations];
    self.current = [self fetchCurrentLocation];
    
    // most recent location update is at the end of the locations array
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Updating locations failed with error: %@", error);
}


// Location methods

-(CLLocation *)fetchCurrentLocation
{
    return (CLLocation *)[self.locations objectAtIndex:([self.locations count]-1)];
}

-(NSString *)returnLocationName:(CLLocation *)location
{
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    NSLog(@"%d", kCLErrorGeocodeFoundNoResult);
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
        }
    }];
    NSLog(@"placemark? %@", self.placemark);
//    return self.placemark.name;
//    return self.placemark.subLocality; // returns "Mission District"
    return [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
            self.placemark.subThoroughfare, self.placemark.thoroughfare,
            self.placemark.postalCode, self.placemark.locality,
            self.placemark.administrativeArea,
            self.placemark.country];
}

-(CLLocation *)getLocationFromData:(NSData *)data
{
    NSDictionary *coords = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
    CLLocationDegrees lat = [[coords objectForKey:@"lat"] doubleValue];
    CLLocationDegrees lon = [[coords objectForKey:@"lon"] doubleValue];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    return location;
}

#pragma mark - MKMapView delegate methods

-(MKMapView *)displayMap:(UIView *)view withAnnotations:(NSMutableArray *)annotations
{
    self.map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [self.map setDelegate:self];

    self.map.showsUserLocation = YES;
    [self.map addAnnotations:annotations];
    
    [annotations addObject:self.map.userLocation];
    [self.map showAnnotations:annotations animated:YES];
    
    MKCoordinateRegion mapRegion; // structure that defines which map region to display
    CLLocation *location = [self fetchCurrentLocation];
    mapRegion.center = location.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    
    [self.map setRegion:mapRegion animated:YES];

    return self.map;
}

//- (void)zoomToLocation
//{
//    CLLocationCoordinate2D zoomLocation;
//    zoomLocation.latitude = 13.03297;
//    zoomLocation.longitude= 80.26518;
//    
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 7.5*METERS_PER_MILE,7.5*METERS_PER_MILE);
//    [self.mapview setRegion:viewRegion animated:YES];
//    
//    [self.mapview regionThatFits:viewRegion];
//}

//MKCoordinateRegion coordinateRegionForCoordinates(CLLocationCoordinate2D *coords, NSUInteger coordCount) {
//    MKMapRect r = MKMapRectNull;
//    for (NSUInteger i=0; i < coordCount; ++i) {
//        MKMapPoint p = MKMapPointForCoordinate(coords[i]);
//        r = MKMapRectUnion(r, MKMapRectMake(p.x, p.y, 0, 0));
//    }
//    return MKCoordinateRegionForMapRect(r);
//}

-(NSMutableArray *)createAnnotationsFromMessages:(NSArray *)array
{
    NSMutableArray *retVal = [NSMutableArray array];
    for (int i = 0; i < [array count]; i++) {
        NSData *data = [((LYRMessage *)[array objectAtIndex:i]).parts lastObject];
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:@"title" AndCoordinate:[self getLocationFromData:data].coordinate];
        [retVal addObject:annotation];
    }
    return retVal;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    return; // not called?
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        MKPinAnnotationView *userLocationPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
        userLocationPin.pinColor = MKPinAnnotationColorPurple;
//        userLocationPin.animatesDrop = YES;
        userLocationPin.canShowCallout = YES;
        ((MKUserLocation *)annotation).title = @"My Location";
        return userLocationPin;
    }
    else{ // for location of each participant...
        MKPinAnnotationView *otherLocationPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil]; // reuser Views when it's for all the other participants
        otherLocationPin.pinColor = MKPinAnnotationColorRed;
        otherLocationPin.canShowCallout = YES;
        return otherLocationPin;
    }
//    [mapView selectAnnotation:annotation animated:false]; // doesn't do anything...
}


@end
