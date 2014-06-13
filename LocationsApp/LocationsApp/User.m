//
//  User.m
//  LocationsApp
//
//  Created by Meera Parat on 6/9/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize name = _name;
@synthesize firstName  = _firstName;
@synthesize location = _location;
@synthesize time = _time;
@synthesize picture = _picture;
//@synthesize fbFriends = _fbFriends;

-(User *)initWithName:(NSString *)text
{
    self.name = text;
    return self;
}

@end
