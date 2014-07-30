//
//  SearchCell.h
//  LocationsApp
//
//  Created by Meera Parat on 6/16/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "parseUser.h"

@interface SearchCell : UITableViewCell

@property (nonatomic, strong) PFUser *signedInUser;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) parseUser *person;


-(void)placeSubviewsForCell:(NSString *)name;

-(void)initWithContact:(parseUser *)user;


@end
