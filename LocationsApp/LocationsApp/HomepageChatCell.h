//
//  HomepageChatCell.h
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "MCSwipeTableViewCell.h"
#import "Contact.h"

@interface HomepageChatCell : MCSwipeTableViewCell 

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Contact *contact;

-(void)placeSubviewsForCellWithName:(Contact *)recipient Location:(NSString *)text Date:(NSDate *)date;
-(void)placeSubviewsForGroupMessageCell:(NSArray *)recipients Location:(NSString *)text Date:(NSDate *)date;


@end
