//
//  FBFriendListTableViewController.h
//  LocationsApp
//
//  Created by Meera Parat on 6/9/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FBFriendListTableViewController : UIViewController <FBFriendPickerDelegate>

-(void)pickFriendsButtonClick:(id)sender;

@end
