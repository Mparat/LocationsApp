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
#import "LayerAPIManager.h"

@class LocationManagerController;

@protocol LocationManagerControllerDelegate <NSObject>

-(void)placemarkUpdated:(NSString *)location forIndexPath:(NSIndexPath *)path;

@end


@interface LocationManagerController : NSObject <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) CLLocation *current;
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) MKMapView *map;
@property (nonatomic, weak) id<LocationManagerControllerDelegate>delegate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) LayerAPIManager *apiManager;



-(void)launchLocationManager;
-(CLLocation *)fetchCurrentLocation;
-(void)returnLocationName:(CLLocation *)location completion:(void(^)(BOOL done, NSError *error))completion;
-(CLLocation *)getLocationFromData:(NSData *)data;
-(NSArray *)createAnnotationsFromMessages:(NSMutableArray *)array;


-(MKMapView *)displayMap:(UIView *)view withAnnotations:(NSArray *)annotations;




@end
