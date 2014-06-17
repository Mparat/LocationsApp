//
//  SearchCell.h
//  LocationsApp
//
//  Created by Meera Parat on 6/16/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell

@property (nonatomic, strong) NSString *username;

-(void)placeSubviewsForCell:(NSString *)name;

@end
