//
//  User.h
//  LocationsApp
//
//  Created by Meera Parat on 6/9/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSMutableArray *friends;

@end
