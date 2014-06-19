//
//  HomepageChatCell.m
//  LocationsApp
//
//  Created by Meera Parat on 6/6/14.
//  Copyright (c) 2014 Meera Parat. All rights reserved.
//

#import "HomepageChatCell.h"
#import "LocationManagerController.h"

@interface HomepageChatCell()

@property (nonatomic, strong) UIImage *contactPic;
@property (nonatomic, strong) UILabel *username;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *location;

@end

@implementation HomepageChatCell

@synthesize user = _user;
@synthesize swipedCellController = _swipedCellController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.user = [[User alloc] initWithName:@"Sam"];
        [self configureViews];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureViews
{
    UILabel *askText = [[UILabel alloc] init];
    UIView *askView = [[UIView alloc] init];
    askText.text = @"Ask";
    askText.textColor = [UIColor blackColor];
    [askView addSubview:askText];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    
    UILabel *tellText = [[UILabel alloc] init];
    UIView *tellView = [[UIView alloc] init];
    tellText.text = @"Ask";
    tellText.textColor = [UIColor blackColor];
    [tellView addSubview:tellText];
    UIColor *yellowColor = [UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0];
    
    
    UILabel *mapText = [[UILabel alloc] init];
    UIView *mapView = [[UIView alloc] init];
    mapText.text = @"Ask";
    mapText.textColor = [UIColor blackColor];
    [mapView addSubview:mapText];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
//    UIColor *brownColor = [UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0];
    
    [self setSwipeGestureWithView:askView color:greenColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Ask\" cell");
    }];
    
    [self setSwipeGestureWithView:tellView color:yellowColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState2 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"tell\" cell");
        
    }];
    
    [self setSwipeGestureWithView:mapView color:redColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"map\" cell");
//        [self.swipedCellController toMap];
    }];
    
    self.firstTrigger = 0.1;
    self.secondTrigger = 0.6;

}

-(void)placeSubviewsForCellWithLocation:(NSString *)text Date:(NSDate *)date
{
    [self addAskButton];
    [self setContactInfoWithLocation:text Date:date];
}

-(void)addAskButton
{
    ask = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // set cell height to be 70;
    // individual chats..
    ask.frame = CGRectMake(self.frame.size.width - 80, 15, 70, 40);
    [ask setTitle:@"Ask" forState:UIControlStateNormal];
    [self addSubview:ask];
    [ask addTarget:self action:@selector(askForLocation) forControlEvents:UIControlEventTouchUpInside];
}

-(void)askForLocation
{
    return;
}

-(void)setContactInfoWithLocation:(NSString *)text Date:(NSDate *)date
{
    // picture: 50 x 50, 10 buffer all around
    
    self.username = [[UILabel alloc] init];
    self.username.text = self.user.name;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.username.font, NSFontAttributeName, nil];
    self.username.frame = CGRectMake(self.username.frame.origin.x,
                                     self.username.frame.origin.y,
                                     [self.username.text sizeWithAttributes:dict].width,
                                     [self.username.text sizeWithAttributes:dict].height);
    
    self.username.frame = CGRectMake(70, 20, self.username.frame.size.width, 16);
    self.username.font = [UIFont fontWithName:@"Helvetica" size:16];
    self.username.textColor = [UIColor blackColor];
    [self addSubview:self.username];
    
    self.location = [[UILabel alloc] init];
    self.location.text = [NSString stringWithFormat:@"%@", text];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:self.location.font, NSFontAttributeName, nil];
    self.location.frame = CGRectMake(self.location.frame.origin.x,
                                     self.location.frame.origin.y,
                                     [self.location.text sizeWithAttributes:dict2].width,
                                     [self.location.text sizeWithAttributes:dict2].height);
    
    self.location.frame = CGRectMake(self.username.frame.origin.x , self.username.frame.origin.y + self.username.frame.size.height, self.location.frame.size.width, 14);
    self.location.font = [UIFont fontWithName:@"Helvetica" size:14];
    self.location.textColor = [UIColor blackColor];
    [self addSubview:self.location];
    
    
    self.time = [[UILabel alloc] init];
    self.time.text = [NSString stringWithFormat:@"%@", date];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:self.time.font, NSFontAttributeName, nil];
    self.time.frame = CGRectMake(self.time.frame.origin.x,
                                     self.time.frame.origin.y,
                                     [self.time.text sizeWithAttributes:dict3].width,
                                     [self.time.text sizeWithAttributes:dict3].height);
    
    self.time.frame = CGRectMake(self.username.frame.origin.x + self.username.frame.size.width, 26, self.time.frame.size.width, 8);
    self.time.font = [UIFont fontWithName:@"Helvetica" size:10];
    self.time.textColor = [UIColor blackColor];
    [self addSubview:self.time];
}

@end
