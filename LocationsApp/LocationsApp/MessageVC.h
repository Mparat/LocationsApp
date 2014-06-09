//
//  MessageVC.h
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MessageVC : UIViewController <UITableViewDelegate>
{
    UIButton *tellLocationButton;
    UIButton *ask;
    UIButton *send;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;

@end
