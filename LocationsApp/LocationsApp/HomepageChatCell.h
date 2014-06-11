//
//  HomepageChatCell.h
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomepageChatCell : UITableViewCell
{
    UIButton *ask;
}

-(void)placeSubviewsForCellWithLocation:(NSString *)text Date:(NSDate *)date;

//@property (nonatomic, strong) Contact *contact;

@end
