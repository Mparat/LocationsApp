//
//  LayerAPIManager.m
//  LocationsApp
//
//  Created by Meera Parat on 8/2/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "LayerAPIManager.h"
#import "Contact.h"

@implementation LayerAPIManager


-(id)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

-(void)registerUser:(PFUser *)user completion:(void (^)(PFUser *, NSError *))completion
{
    
}

-(void)authenticateWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(PFUser *, NSError *))completion
{
    [self.layerClient requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
        if (!nonce) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
                NSLog(@"No nonce");
            });
            return;
        }
        if (error) {
            NSLog(@"Error requesting nonce: %@", error);
            return;
        }
        PFUser *user = [PFUser currentUser];
        NSString *userID  = user.objectId;
        [PFCloud callFunctionInBackground:@"generateToken"
                           withParameters:@{@"nonce" : nonce,
                                            @"userID" : userID}
                                    block:^(NSString *token, NSError *error) {
            if (error) {
                NSLog(@"Parse Cloud function failed to be called to generate token with error: %@", error);
            }
            else{
                NSLog(@"token is: %@",  token);
                [self.layerClient authenticateWithIdentityToken:token completion:^(NSString *authenticatedUserID, NSError *error) {
                    if (error) {
                        //
                    }
                    else{
                        NSLog(@"authenticated with token");
                    }
                }];
            }
        }];
    }];
    NSLog(@"client: %@", self.layerClient);
}

-(void)deauthenticateWithCompletion:(void (^)(BOOL, NSError *))completion
{
    [PFUser logOut];
    if (completion){
        [self.layerClient deauthenticate];
        NSLog(@"User deauthenticated");
    }
}

-(void)sendAskMessageToRecipients:(NSArray *)recipients //this actually is just a notification... not a messagePart in the convo.......
{
    // filter recipients into new array with only other participants userIDs
    NSMutableArray *uids = [NSMutableArray array];
    for (int i = 0; i < [recipients count]; i++) {
        if (![self.layerClient.authenticatedUserID isEqualToString:((Contact *)[recipients objectAtIndex:i]).userID]) {
            [uids addObject:((Contact *)[recipients objectAtIndex:i]).userID];
        }
    }
    LYRConversation *conversation = [self.layerClient conversationForParticipants:uids];
    
    // if conversation is new (will happen only once, from  AddressBookTVC), assign metadata to it
    if (conversation.metadata == NULL) {
        NSDictionary *metadata = @{@"participants" : recipients};
        [self.layerClient setMetadata:metadata onObject:conversation];
    }
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithText:@"just a notification asking.. hmm"];
    LYRMessage *message = [LYRMessage messageWithConversation:conversation parts:@[messagePart]];
    
    // constructed the message for the conversation. Now send it.
    BOOL success = [self.layerClient sendMessage:message error:nil];
    if (success) {
        NSLog(@"Message send succesfull");
    } else {
        NSLog(@"Message send failed");
    }
}

-(void)sendTellMessageToRecipients:(NSArray *)recipients
{
    NSMutableArray *uids = [NSMutableArray array];
    for (int i = 0; i < [recipients count]; i++) {
        if (![self.layerClient.authenticatedUserID isEqualToString:((Contact *)[recipients objectAtIndex:i]).userID]) {
            [uids addObject:((Contact *)[recipients objectAtIndex:i]).userID];
        }
    }
    
    LYRConversation *conversation = [self.layerClient conversationForParticipants:uids];
    if (conversation.metadata == NULL) {
        NSDictionary *metadata = @{@"participants" : recipients};
        [self.layerClient setMetadata:metadata onObject:conversation];
    }
    CLLocation *current = [self.locationManager fetchCurrentLocation];
    
//    NSString *text = [self.locationManager returnMyLocationName:current];

    // MIME type declaration
    static NSString *const MIMETypeLocation = @"location";
    
    // Creates a message part with latitude and longitude strings
    NSDictionary *location = @{@"lat"  :  [NSNumber numberWithDouble:current.coordinate.latitude],
                               @"lon"  :  [NSNumber numberWithDouble:current.coordinate.longitude]};
    
    NSData *locationData = [NSJSONSerialization dataWithJSONObject:location options:nil error:nil];
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithMIMEType:MIMETypeLocation data:locationData];
    
//    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithText:text];
    LYRMessage *message = [LYRMessage messageWithConversation:conversation parts:@[messagePart]];
    BOOL success = [self.layerClient sendMessage:message error:nil];
    if (success) {
        NSLog(@"Message send succesfull");
    } else {
        NSLog(@"Message send failed");
    }
}

-(NSMutableArray *)returnParticipants:(LYRConversation *)conversation
{
    NSArray *participants = [NSArray arrayWithArray: [conversation.metadata objectForKey:@"participants"]]; //array of all Contacts/participants with all info
    NSMutableArray *recipients = [NSMutableArray arrayWithArray:participants];
    for (int i = 0; i < [participants count]; i++) {
        if ([((Contact *)[recipients objectAtIndex:i]).userID isEqualToString:self.layerClient.authenticatedUserID]) {
            [recipients removeObject:[recipients objectAtIndex:i]];
        }
    }
    return recipients;
}


@end
