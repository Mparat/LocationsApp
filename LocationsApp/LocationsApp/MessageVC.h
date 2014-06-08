//
//  MessageVC.h
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageVC : UIViewController <UITableViewDelegate>
{
    UIButton *tellLocationButton;
    UIButton *send;
    UIButton *viewMap;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;

@end
