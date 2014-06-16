//
//  MessageVC.m
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "MessageVC.h"
#import "HomepageChatCell.h"
#import "HomepageTVC.h"
#import "MapVC.h"

@interface MessageVC ()

@end

@implementation MessageVC

@synthesize tableView;
@synthesize locationManager = _locationManager;
@synthesize recipient = _recipient;
@synthesize signedInUser = _signedInUser;
@synthesize user = _user;

#define userCellIdentifier @"userCell"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeTextField];
    [self addNavBarButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)loadView
//{
//    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) style:UITableViewStyleGrouped];
//    [self.view addSubview:tableView];
//    tableView.delegate = self;
//}

-(void) addNavBarButton
{
//    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
//    [back addTarget:self action:@selector(backToHomepage) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *viewMap = [[UIButton alloc] initWithFrame:CGRectMake(8*self.view.frame.size.width/10, 5, 2*self.view.frame.size.width/10, 20)];
    [viewMap setTitle:@"Map" forState:UIControlStateNormal];
    [viewMap setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [viewMap addTarget:self action:@selector(viewMap) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *viewMapButton = [[UIBarButtonItem alloc] initWithCustomView:viewMap];
    self.navigationItem.rightBarButtonItem = viewMapButton;
    self.navigationItem.title= self.recipient.name;
}
//
//-(void)backToHomepage
//{
//    HomepageTVC *homepage = [[HomepageTVC alloc] init];
//    [homepage setLocationManager:self.locationManager];
//    homepage.signedInUser = self.signedInUser;
//    [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:homepage] animated:TRUE completion:^{
//        //
//    }];
//}

-(void)viewMap
{
    MapVC *mapView = [[MapVC alloc] init];
    mapView.locationManager = self.locationManager;
    mapView.signedInUser = self.signedInUser;
    [self.navigationController pushViewController:mapView animated:YES];
}

#pragma mark - Text Field delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)initializeTextField
{
    self.textField = [[UITextField alloc] init];
    self.textField.placeholder = [NSString stringWithFormat:@"Message"];
    self.textField.frame = CGRectMake(self.view.frame.size.width/15, self.view.frame.size.height - 40, 7.5*self.view.frame.size.width/10, 30);
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.textAlignment = NSTextAlignmentNatural;
    self.textField.delegate = self;
    [self.view addSubview:self.textField];

    send = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    send.frame = CGRectMake(8*self.view.frame.size.width/10 + 10, self.view.frame.size.height - 40, 40, 30);
    [send setTitle:@"Send" forState:UIControlStateNormal];
    [send setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:send];
    [send addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
    
    tellLocationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tellLocationButton.frame = CGRectMake(1*self.view.frame.size.width/10, self.textField.frame.origin.y - 33, 6*self.view.frame.size.width/10, 25);
    [tellLocationButton setTitle:@"Tell Location" forState:UIControlStateNormal];
    tellLocationButton.backgroundColor = [UIColor blueColor];
    tellLocationButton.layer.cornerRadius = 10;
    [self.view addSubview:tellLocationButton];
    [tellLocationButton addTarget:self action:@selector(sendLocation) forControlEvents:UIControlEventTouchUpInside];
    
    ask = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    ask.frame = CGRectMake(7.5*self.view.frame.size.width/10, self.textField.frame.origin.y - 33, 1.5*self.view.frame.size.width/10, 25);
    [ask setTitle:@"Ask" forState:UIControlStateNormal];
    ask.backgroundColor = [UIColor blueColor];
    ask.layer.cornerRadius = 10;
    [self.view addSubview:ask];
    [ask addTarget:self action:@selector(askLocation) forControlEvents:UIControlEventTouchUpInside];
}

-(void)sendLocation // Configure the location time, etc before sending, not upon recieving, because that's when it is sent and accurate...
{
    [self configureLocation];
}

-(void)configureLocation
{
    CLLocation *myLocation = [self.locationManager fetchCurrentLocation];
    PFGeoPoint *parseGeoPoint = [PFGeoPoint geoPointWithLocation:myLocation];
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    static NSNumberFormatter *numberFormatter = nil;
    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMaximumFractionDigits:3];
    }
    
    self.user.name = self.signedInUser.username;
    self.user.location = [self.locationManager returnMyLocationName:myLocation];
    self.user.time = [dateFormatter stringFromDate:myLocation.timestamp];
    self.user.picture = NULL;
    
//    PFObject *myInfoObject = [PFObject objectWithClassName:@"myInfo"]; // Do I need to save the object to parse?
//    [myInfoObject setObject:self.user forKey:@"myInfo"];

    
    // send time, name, coordinates (for mapping)
}

-(void)askLocation
{
    return;
}

-(void)sendText
{
    return;
}

#pragma mark - Table View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)index
{
    HomepageChatCell *cell = [self.tableView dequeueReusableCellWithIdentifier:userCellIdentifier];
    return cell;
}

#pragma mark - Keyboard handling

// Subscribe to keyboard show/hide notifications.
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification object:nil];
}

// Unsubscribe from keyboard show/hide notifications.
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Setup keyboard handlers to slide the view containing the table view and
// text field upwards when the keyboard shows, and downwards when it hides.
- (void)keyboardWillShow:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:NO];
}

- (void)moveView:(NSDictionary*)userInfo up:(BOOL)up
{
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     getValue:&keyboardEndFrame];
    
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
     getValue:&animationCurve];
    
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
     getValue:&animationDuration];
    
    // Get the correct keyboard size to we slide the right amount.
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    int y = keyboardFrame.size.height * (up ? -1 : 1);
    self.view.frame = CGRectOffset(self.view.frame, 0, y);
    
    [UIView commitAnimations];
}

// This method will be called when the user touches on the tableView, at
// which point we will hide the keyboard (if open). This method is called
// because UITouchTableView.m calls nextResponder in its touch handler.
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}


@end
