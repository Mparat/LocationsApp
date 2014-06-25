//
//  ContactCell.h
//  LocationsApp
//
//  Created by Meera Parat on 6/25/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface ContactCell : UITableViewCell

@property (nonatomic, strong) Contact *contact;

-(void)initWithContact:(Contact *)friend;

@end
