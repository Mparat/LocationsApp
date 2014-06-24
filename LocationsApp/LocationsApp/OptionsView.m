//
//  OptionsView.m
//  LocationsApp
//
//  Created by Meera Parat on 6/24/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "OptionsView.h"

@interface OptionsView ()

@end

@implementation OptionsView

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize recipient = _recipient;
@synthesize signedInUser = _signedInUser;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initButtons
{
    UIButton *sendSMS = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 100, 100)];
    [sendSMS setTitle:@"Text" forState:UIControlStateNormal];
    [sendSMS setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sendSMS addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendSMS];
}

-(void)sendText
{
//    NSNumber *number = [self.recipient objectForKey:@"phoneNumber"];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", number]]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:16507964182"]];
}


@end
