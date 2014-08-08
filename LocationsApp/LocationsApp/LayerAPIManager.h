//
//  LayerAPIManager.h
//  LocationsApp
//
//  Created by Meera Parat on 8/2/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <LayerKit/LayerKit.h>
#import "LocationManagerController.h"

@interface LayerAPIManager : NSObject

@property (nonatomic, strong) LYRClient *layerClient;

-(void)authenticateWithEmail:(NSString *)email password:(NSString *)password completion:(void(^)(PFUser *user, NSError *error))completion;
-(void)registerUser:(PFUser *)user completion:(void(^)(PFUser *user, NSError *error))completion;
//- (BOOL)resumeSession:(LSSession *)session error:(NSError **)error;
- (void)deauthenticateWithCompletion:(void(^)(BOOL success, NSError *error))completion;

-(void)sendAskMessageToRecipients:(NSArray *)recipients;
-(void)sendTellMessageToRecipients:(NSArray *)recipients;
-(NSMutableArray *)returnParticipants:(LYRConversation *)conversation;

@property (nonatomic, strong) LocationManagerController *locationManager;

@end
