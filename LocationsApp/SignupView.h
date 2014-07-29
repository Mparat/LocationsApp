//
//  SignupView.h
//  LocationsApp
//
//  Created by Meera Parat on 7/28/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignupView : UIViewController <PFSignUpViewControllerDelegate>

@property (nonatomic, strong) PFSignUpViewController *parseSignupVC;
@property (nonatomic, strong) PFSignUpView *signupView;

@property (nonatomic, strong) UITextField *firstName;
@property (nonatomic, strong) UITextField *lastName;
@property (nonatomic, strong) UITextField *email; //username
@property (nonatomic, strong) UITextField *password;


@end
