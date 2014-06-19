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

@interface HomepageChatCell : MCSwipeTableViewCell
{
    UIButton *ask;
}

@property (nonatomic, strong) User *user;
-(void)placeSubviewsForCellWithName:(NSString *)name Location:(NSString *)text Date:(NSDate *)date;


//@property (nonatomic, strong) Contact *contact;

@end
