//
//  MessageVC.m
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "MessageVC.h"
#import "HomepageChatCell.h"

@interface MessageVC ()

@end

@implementation MessageVC

@synthesize tableView;
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
//    [self loadView];
//    [self.tableView reloadData];

    
    // Do any additional setup after loading the view.
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

-(void)viewMap
{
    return;
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
    tellLocationButton.frame = CGRectMake(2*self.view.frame.size.width/10, self.textField.frame.origin.y - 30, 6*self.view.frame.size.width/10, 20);
    [tellLocationButton setTitle:@"Tell Location" forState:UIControlStateNormal];
    tellLocationButton.backgroundColor = [UIColor blueColor];
    tellLocationButton.layer.cornerRadius = 10;
    [self.view addSubview:tellLocationButton];
    [tellLocationButton addTarget:self action:@selector(sendLocation) forControlEvents:UIControlEventTouchUpInside];
}

-(void)sendLocation
{
    return;
}

-(void)sendText
{
    return;
}

#pragma mark - Table View data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    viewMap = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    viewMap.frame = CGRectMake(8*header.frame.size.width/10, 5, 2*header.frame.size.width/10, 20);
    [viewMap setTitle:@"Map" forState:UIControlStateNormal];
    [header addSubview:viewMap];
    [viewMap addTarget:self action:@selector(viewMap) forControlEvents:UIControlEventTouchUpInside];
    
    return header;
}

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
