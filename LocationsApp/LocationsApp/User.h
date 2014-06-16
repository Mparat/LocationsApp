//
//  User.h
//  LocationsApp
//
//  Created by Meera Parat on 6/9/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) UIImage *picture;

//@property (nonatomic, strong) NSMutableArray *fbFriends;

-(User *)initWithName:(NSString *)text;

@end
