//
//  FBFriendListTableViewController.m
//  LocationsApp
//
//  Created by Meera Parat on 6/9/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "FBFriendListTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FBFriendListTableViewController ()

@property (nonatomic, strong) FBFriendPickerViewController *friendPickerController;
@property (nonatomic, strong) UITextView *selectedFriendsView;
-(void)fillTextBoxAndDismiss:(NSString *)text;

@end

@implementation FBFriendListTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self pickFriendsButtonClick:self];
}

-(void)viewDidUnload{
    self.selectedFriendsView = nil;
    self.friendPickerController = nil;
    [super viewDidUnload];
}

-(void)createSelectedFriendsView
{
    self.selectedFriendsView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    self.selectedFriendsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.selectedFriendsView];
}

#pragma mark - UI handlers

-(void)pickFriendsButtonClick:(id)sender{
    if (!FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_friends"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                              [alertView show];
                                          }
                                          else if (session.isOpen){
                                              [self pickFriendsButtonClick:sender];
                                          }
                                      }];
        return;
    }
    if (self.friendPickerController == nil){
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Pick Friends";
        self.friendPickerController.delegate = self;
    }
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    [self.navigationController presentViewController:[[UINavigationController alloc]initWithRootViewController:self.friendPickerController] animated:TRUE completion:^{
        //
    }];
}

-(void)facebookViewControllerDoneWasPressed:(id)sender
{
    NSMutableString *text = [[NSMutableString alloc] init];
    for (id<FBGraphUser> user in self.friendPickerController.selection) {
        if ([text length]) {
            [text appendString:@", "];
        }
        [text appendString:user.name];
    }
    [self fillTextBoxAndDismiss:text.length > 0 ? text : @"<None>"];
}

-(void)facebookViewControllerCancelWasPressed:(id)sender{
    [self fillTextBoxAndDismiss:@"<Cancelled>"];
}

-(void)fillTextBoxAndDismiss:(NSString *)text
{
    self.selectedFriendsView.text = text;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}




@end
