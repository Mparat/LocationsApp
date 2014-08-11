//
//  LayerAPIManager.m
//  LocationsApp
//
//  Created by Meera Parat on 8/2/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "LayerAPIManager.h"
#import "Contact.h"
#import "LayerClientController.h"

@implementation LayerAPIManager


-(id)initWithLayerClient:(LYRClient *)client
{
    self = [super init];
    if (self) {
        self.layerClient = client;
    }
    return self;
}

-(void)authenticateWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(PFUser *, NSError *))completion
{
    NSParameterAssert(completion);

    [self.layerClient requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
        if (!nonce) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
                NSLog(@"No nonce");
            });
            completion(nil, error);
            return;
        }
        if (error) {
            NSLog(@"Error requesting nonce: %@", error);
            completion(nil, error);
            return;
        }
        else{
            PFUser *user = [PFUser currentUser];
            NSString *userID  = user.objectId;
            [PFCloud callFunctionInBackground:@"generateToken"
                               withParameters:@{@"nonce" : nonce,
                                                @"userID" : userID}
                                        block:^(NSString *token, NSError *error) {
                                            if (error) {
                                                NSLog(@"Parse Cloud function failed to be called to generate token with error: %@", error);
                                                completion(nil, error);
                                            }
                                            else{
                                                [self.layerClient authenticateWithIdentityToken:token completion:^(NSString *authenticatedUserID, NSError *error) {
                                                    if (error) {
                                                        completion(nil, error);
                                                    }
                                                    else{
                                                        NSLog(@"authenticated with token");
                                                        completion([PFUser currentUser], nil);
                                                    }
                                                }];
                                                
                                            }
                                            
                                        }];
        }
    }];
}

-(void)logoutWithCompletion:(void (^)(BOOL, NSError *))completion
{
    [PFUser logOut];
    [self.layerClient deauthenticateWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"User deauthenticated");
            completion(YES, nil);
        }
    }];
}

-(void)sendAskMessageToRecipients:(NSMutableDictionary *)recipients //this actually is just a notification... not a messagePart in the convo.......
{
    // filter recipients into new array with only other participants userIDs
    NSArray *uids = [recipients allKeys];
//    NSArray *temp = [recipients allKeys];
//    NSMutableArray *uids = [NSMutableArray arrayWithArray:temp];
//    [uids removeObject:self.layerClient.authenticatedUserID];
    
    LYRConversation *conversation = [[LYRConversation alloc] init];
    if ([self.layerClient conversationForParticipants:uids]) {
        conversation = [self.layerClient conversationForParticipants:uids];
    } else {
        conversation = [LYRConversation conversationWithParticipants:uids];
    }
    
    static NSString *const MIMETypeArray = @"participants";
    
    NSData *recipientData = [NSJSONSerialization dataWithJSONObject:recipients options:nil error:nil];
    LYRMessagePart *recipientArr = [LYRMessagePart messagePartWithMIMEType:MIMETypeArray data:recipientData];
    
    
    // MIME type declaration
    static NSString *const MIMETypeLocation = @"location";
    CLLocation *current = [self.locationManager fetchCurrentLocation];
    
    // Creates a message part with latitude and longitude strings
    NSDictionary *location = [NSMutableDictionary dictionary];
    [location setValue:[NSNumber numberWithDouble:current.coordinate.latitude] forKey:@"lat"];
    [location setValue:[NSNumber numberWithDouble:current.coordinate.longitude] forKey:@"lon"];
    
    NSData *locationData = [NSJSONSerialization dataWithJSONObject:location options:nil error:nil];
    LYRMessagePart *locationPart = [LYRMessagePart messagePartWithMIMEType:MIMETypeLocation data:locationData];
    
    LYRMessage *message = [LYRMessage messageWithConversation:conversation parts:@[recipientArr, locationPart]];
    [self.layerClient setMetadata:@{LYRMessagePushNotificationAlertMessageKey: @"Someone you for your location!"} onObject:message];

    BOOL success = [self.layerClient sendMessage:message error:nil];
    if (success) {
        NSLog(@"Message send succesfull");
    } else {
        NSLog(@"Message send failed");
    }
}

-(void)sendTellMessageToRecipients:(NSMutableDictionary *)recipients
{
    // filter recipients into new array with only other participants userIDs
    NSArray *uids = [recipients allKeys];
    
    LYRConversation *conversation = [[LYRConversation alloc] init];
    if ([self.layerClient conversationForParticipants:uids] != nil) {
        conversation = [self.layerClient conversationForParticipants:uids];
    }
    else {
        conversation = [LYRConversation conversationWithParticipants:uids];
    }
    
    static NSString *const MIMETypeArray = @"participants";
    
    NSData *recipientData = [NSJSONSerialization dataWithJSONObject:recipients options:nil error:nil];
    LYRMessagePart *recipientArr = [LYRMessagePart messagePartWithMIMEType:MIMETypeArray data:recipientData];
  

    // MIME type declaration
    static NSString *const MIMETypeLocation = @"location";
    CLLocation *current = [self.locationManager fetchCurrentLocation];

    // Creates a message part with latitude and longitude strings
    NSDictionary *location = [NSMutableDictionary dictionary];
    [location setValue:[NSNumber numberWithDouble:current.coordinate.latitude] forKey:@"lat"];
    [location setValue:[NSNumber numberWithDouble:current.coordinate.longitude] forKey:@"lon"];
    
    NSData *locationData = [NSJSONSerialization dataWithJSONObject:location options:nil error:nil];
    LYRMessagePart *locationPart = [LYRMessagePart messagePartWithMIMEType:MIMETypeLocation data:locationData];
    
    LYRMessage *message = [LYRMessage messageWithConversation:conversation parts:@[recipientArr, locationPart]];

    
    // Configure the push notification text to be the same as the message text
    [self.layerClient setMetadata:@{LYRMessagePushNotificationAlertMessageKey: @"Someone told you their location!"} onObject:message];
    
    BOOL success = [self.layerClient sendMessage:message error:nil];
    if (success) {
        NSLog(@"Message send succesfull");
    } else {
        NSLog(@"Message send failed");
    }
}

-(NSMutableDictionary *)returnParticipantDictionary:(LYRConversation *)conversation
{
    LYRMessage *lastMessage = [[self.layerClient messagesForConversation:conversation] lastObject];
    LYRMessagePart *part1 = [lastMessage.parts objectAtIndex:0];
    NSData *contacts = part1.data;
    NSMutableDictionary *recipientInfo = [NSJSONSerialization JSONObjectWithData:contacts options:nil error:nil];
    return recipientInfo;
}

-(NSMutableArray *)recipientUserIDs:(LYRConversation *)conversation
{
    NSMutableArray *ret = [NSMutableArray array];
    for (NSString *userID in conversation.participants) {
        if (![userID isEqualToString:self.layerClient.authenticatedUserID]) {
            [ret addObject:userID];
        }
    }
    return ret;
}

-(NSArray *)personFromConversation:(LYRConversation *)conversation forUserID:(NSString *)uid
{
    LYRMessage *lastMessage = [[self.layerClient messagesForConversation:conversation] lastObject];
    LYRMessagePart *part1 = [lastMessage.parts objectAtIndex:0];
    NSData *contacts = part1.data;
    NSMutableDictionary *recipientInfo = [NSJSONSerialization JSONObjectWithData:contacts options:nil error:nil];
    return [recipientInfo objectForKey:uid];
}

-(NSArray *)personFromMessage:(LYRMessage *)message forUserID:(NSString *)uid
{
    LYRMessagePart *recipientPart = [message.parts objectAtIndex:0];
    NSData *data = recipientPart.data;
    NSMutableDictionary *recipientInfo = [NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
    return [recipientInfo objectForKey:uid];
}

-(NSMutableArray *)groupNameFromConversation:(LYRConversation *)conversation
{
    NSMutableArray *names = [NSMutableArray array];
    for (int i = 0; i < [[self recipientUserIDs:conversation] count]; i++) {
        NSArray *temp = [self personFromConversation:conversation forUserID:[[self recipientUserIDs:conversation] objectAtIndex:i]];
        [names addObject:[temp objectAtIndex:1]];
    }
    return names;
}


@end
