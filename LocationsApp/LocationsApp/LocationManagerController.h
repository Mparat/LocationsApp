//
//  LocationManagerController.h
//  LocationsApp
//
//  Created by Meera Parat on 6/10/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <LayerKit/LayerKit.h>

@class LocationManagerController;

@protocol LocationManagerControllerDelegate <NSObject>

-(void)placemarkUpdated:(NSString *)location forIndexPath:(NSIndexPath *)path;

@end


@interface LocationManagerController : NSObject <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) CLLocation *current;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) MKMapView *map;
@property (nonatomic, weak) id<LocationManagerControllerDelegate>delegate;

-(void)launchLocationManager;
-(CLLocation *)fetchCurrentLocation;
-(NSString *)returnLocationName:(CLLocation *)location;
-(CLLocation *)getLocationFromData:(NSData *)data;
-(NSArray *)createAnnotationsFromMessages:(NSArray *)array;


-(MKMapView *)displayMap:(UIView *)view withAnnotations:(NSArray *)annotations;




@end
