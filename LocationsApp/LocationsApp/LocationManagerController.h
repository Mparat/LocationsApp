//
//  LocationManagerController.h
//  LocationsApp
//
//  Created by Meera Parat on 6/10/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManagerController : NSObject <CLLocationManagerDelegate>
//{
//    CLLocationManager *manager;
//}
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *locations;

-(void)launchLocationManager;
-(CLLocation *)fetchCurrentLocation;

@end
