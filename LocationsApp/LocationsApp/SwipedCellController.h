//
//  SwipedCellController.h
//  LocationsApp
//
//  Created by Meera Parat on 6/18/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseController.h"
#import "LocationManagerController.h"
#import <Parse/Parse.h>


@class SwipedCellController;

@protocol SwipedCellControllerDelegate <NSObject>

@end


@interface SwipedCellController : UIViewController

@property (nonatomic, weak) id<SwipedCellControllerDelegate> delegate;


@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) ParseController *parseController;
@property (nonatomic, strong) PFUser *signedInUser;

-(void)toMap;


@end
