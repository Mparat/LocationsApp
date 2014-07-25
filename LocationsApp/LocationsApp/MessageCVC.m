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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addNavBar
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:239.0/255.0 green:61.0/255.0 blue:91.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.navigationItem.title = [NSString stringWithFormat:@"%@", self.recipient.firstName];
}

-(void)initializeTextField
{
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(-1, 523, self.view.frame.size.width+2, 46)];
    bottom.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    bottom.layer.borderColor = [[UIColor colorWithRed:173.0/255.0 green:173.0/255.0 blue:173.0/255.0 alpha:1.0] CGColor];
    bottom.layer.borderWidth = 0.5f;
    [self.view addSubview:bottom];
    self.textField = [[UITextField alloc] init];
    self.textField.placeholder = [NSString stringWithFormat:@"Message"];
    [bottom addSubview:self.textField];
    self.textField.frame = CGRectMake(30+1, 8, 225, 29);
    self.textField.layer.borderColor = [[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] CGColor];
//    self.textField.layer.borderWidth = 1.0f;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    self.textField.textAlignment = NSTextAlignmentNatural;
    self.textField.delegate = self;
    
    UIButton *send = [[UIButton alloc] init];
    [bottom addSubview:send];
    send.frame = CGRectMake(262.5+1, 12.5, 50, 20);
    [send setTitle:@"Send" forState:UIControlStateNormal];
//    send.titleLabel.text = @"Send";
//    send.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    [send setTitleColor:[UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1.0] forState:UIControlStateNormal];
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
    [self initializeTextField];
    [self addNavBar];

    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

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
