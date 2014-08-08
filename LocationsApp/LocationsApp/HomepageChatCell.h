//
//  HomepageChatCell.h
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>
#import "User.h"
#import "MCSwipeTableViewCell.h"
#import "Contact.h"
#import "LocationManagerController.h"
#import "LayerAPIManager.h"

@interface HomepageChatCell : MCSwipeTableViewCell 

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Contact *contact;
@property CGFloat height;
@property (nonatomic, strong) LYRClient *layerClient;
@property (nonatomic, strong) NSArray *participants;
@property (nonatomic, strong) LocationManagerController *locationManager;
@property (nonatomic, strong) LayerAPIManager *apiManager;


-(void)placeSubviewsForCellWithName:(Contact *)recipient Location:(NSString *)text Date:(NSDate *)date;
-(void)placeSubviewsForGroupMessageCell:(NSArray *)recipients Location:(NSString *)text Date:(NSDate *)date;

-(void)createCellWith:(LYRConversation *)conversation message:(LYRMessage *)lastMessage layerClient:(LYRClient *)client;

@end
