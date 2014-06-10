//
//  FBFriendPickerController.h
//  LocationsApp
//
//  Created by Meera Parat on 6/9/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FBFriendPickerController : NSObject <FBFriendPickerDelegate>

@property (nonatomic, strong) FBFriendPickerViewController *friendpickercontroller;

@end
