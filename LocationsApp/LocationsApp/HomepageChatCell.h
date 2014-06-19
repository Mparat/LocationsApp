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
#import "SwipedCellController.h"

@interface HomepageChatCell : MCSwipeTableViewCell <SwipedCellControllerDelegate>
{
    UIButton *ask;
}

@property (nonatomic, strong) SwipedCellController *swipedCellController;
@property (nonatomic, strong) User *user;
-(void)placeSubviewsForCellWithLocation:(NSString *)text Date:(NSDate *)date;

//@property (nonatomic, strong) Contact *contact;

@end
