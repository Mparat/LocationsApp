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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.user = [[User alloc] initWithName:@"Sam"];
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
