//
//  HomepageChatCell.h
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManagerController.h"


@interface HomepageChatCell : UITableViewCell
{
    UIButton *ask;
}

@property (nonatomic, strong) LocationManagerController *locationManager;

-(void)placeSubviewsForCell;

//@property (nonatomic, strong) Contact *contact;

@end
