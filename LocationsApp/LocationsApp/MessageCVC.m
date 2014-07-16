//
//  MessageCVC.m
//  LocationsApp
//
//  Created by Meera Parat on 7/2/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "MessageCVC.h"
#import "MessageCell.h"
#import "OptionsView.h"

@interface MessageCVC ()

@end

@implementation MessageCVC

@synthesize locationManager = _locationManager;
@synthesize parseController = _parseController;
@synthesize recipient = _recipient;
@synthesize me = _me;

#define messageCell @"messageCell"


-(id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.backgroundView = [[UIView alloc] init];
        [self.collectionView.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesBegan:withEvent:)]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[MessageCell class] forCellWithReuseIdentifier:messageCell];
    [self initializeTextField];
    [self addNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addNavBar
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:205.0/255.0 blue:6.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    self.navigationItem.title = [NSString stringWithFormat:@"%@", self.recipient.firstName];
}

-(void)initializeTextField
{
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 50)];
    bottom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottom];
    self.textField = [[UITextField alloc] init];
    self.textField.placeholder = [NSString stringWithFormat:@"Message"];
    self.textField.frame = CGRectMake(self.view.frame.size.width/15, 10, 7.5*self.view.frame.size.width/10, 30);
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.textAlignment = NSTextAlignmentNatural;
    self.textField.delegate = self;
    [bottom addSubview:self.textField];
    
    UIButton *send = [[UIButton alloc] init];
    send = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    send.backgroundColor = [UIColor blueColor];
    send.layer.borderColor = [UIColor blueColor].CGColor;
    send.layer.borderWidth = 1.0f;
    send.layer.cornerRadius = 10;
    send.frame = CGRectMake(self.textField.frame.size.width + 25, 10, 50, 30);
    [send setTitle:@" Send" forState:UIControlStateNormal];
    [send setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [bottom addSubview:send];
    [send addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
}

-(void)sendText
{
    //
}

- (void) animations
{
    [UIView animateWithDuration:1.0f animations:^{
        self.textField.frame = CGRectMake(100, 100, 100, 100);
    }];
    
    [UIView animateWithDuration:1.0f animations:^{
        //
    } completion:^(BOOL finished) {
        //
    }];
    
    [UIView animateWithDuration:1.0f delay:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
        //
    } completion:^(BOOL finished) {
        //
    }];
    
}
#pragma mark - Collection View Data Sources

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 20; // number of messages
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2; //number of message parts per message
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1; // between sections horizontally?
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


// The cell that is returned must be retrieved from a call to - dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:messageCell forIndexPath:indexPath];
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout methods

- (CGSize)collectionViewContentSize
{
//    // Don't scroll horizontally
//    CGFloat contentWidth = self.collectionView.bounds.size.width;
//    
//    // Scroll vertically to display a full day
//    CGFloat contentHeight = self.collectionView.bounds.size.height;
//    
//    CGSize contentSize = CGSizeMake(contentWidth, contentHeight);
//    return contentSize;

    return self.collectionViewLayout.collectionViewContentSize;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 30);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 6, 0); // left/right alignment depends on if message is from user or from participant(s)
}

#pragma mark - TextField Delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Keyboard handling

// Subscribe to keyboard show/hide notifications.
- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBarHidden = NO;

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
