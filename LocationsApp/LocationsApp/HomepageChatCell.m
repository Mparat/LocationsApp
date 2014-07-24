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
@synthesize contact = _contact;
@synthesize height = _height;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *read = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReadCircle"]];
        read.frame = CGRectMake(15, 19.5, 29, 29);
        [self addSubview:read];
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

-(void)placeSubviewsForCellWithName:(Contact *)recipient Location:(NSString *)text Date:(NSDate *)date
{
    [self setContactInfoWithName:recipient.firstName Location:text Date:date];
}

-(void)placeSubviewsForGroupMessageCell:(NSArray *)recipients Location:(NSString *)text Date:(NSDate *)date
{
    NSString *names = @"";
    for (int i = 0 ; i < [recipients count]; i++) {
        if (i == 0) {
            names = [NSString stringWithFormat:@"%@%@", names, ((Contact *)[recipients objectAtIndex:i]).firstName];
        }
        if (i > 0) {
            names = [NSString stringWithFormat:@"%@, %@", names, ((Contact *)[recipients objectAtIndex:i]).firstName];
        }
    }
//    [self setGroupMessageCell:recipients Location:text Date:date];
    [self setContactInfoWithName:names Location:text Date:nil];
    [self addExtendIcon];
}

-(void)askForLocation
{
    return;
}

-(void)setContactInfoWithName:(NSString *)name Location:(NSString *)text Date:(NSDate *)date
{
    // picture: 50 x 50, 10 buffer all around
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
//    [timeFormat setDateFormat:@"hh:mm a"];
    [timeFormat setTimeStyle:NSDateFormatterShortStyle];
    NSString *theTime = [timeFormat stringFromDate:date];

    self.time = [[UILabel alloc] init];
//    self.time.text = [NSString stringWithFormat:@"%@", date];
    self.time.text = theTime;
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:self.time.font, NSFontAttributeName, nil];
    self.time.frame = CGRectMake(self.time.frame.origin.x,
                                 self.time.frame.origin.y,
                                 [self.time.text sizeWithAttributes:dict3].width,
                                 [self.time.text sizeWithAttributes:dict3].height);
    
    self.time.frame = CGRectMake(240, 14, self.time.frame.size.width, 18);
    self.time.font = [UIFont fontWithName:@"Helvetica" size:15];
    self.time.textColor = [UIColor grayColor];
    [self addSubview:self.time];
    
    self.username = [[UILabel alloc] init];
    self.username.text = name;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.username.font, NSFontAttributeName, nil];
    self.username.frame = CGRectMake(self.username.frame.origin.x,
                                     self.username.frame.origin.y,
                                     [self.username.text sizeWithAttributes:dict].width,
                                     [self.username.text sizeWithAttributes:dict].height);
    
    self.username.frame = CGRectMake(55, 14, 170, 20);
    self.username.font = [UIFont fontWithName:@"Helvetica" size:17];
    self.username.textColor = [UIColor blackColor];
    [self addSubview:self.username];
    
    self.location = [[UILabel alloc] init];
    self.location.text = [NSString stringWithFormat:@"%@", text];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:self.location.font, NSFontAttributeName, nil];
    self.location.frame = CGRectMake(self.location.frame.origin.x,
                                     self.location.frame.origin.y,
                                     [self.location.text sizeWithAttributes:dict2].width,
                                     [self.location.text sizeWithAttributes:dict2].height);
    
    self.location.frame = CGRectMake(self.username.frame.origin.x , 32, self.location.frame.size.width, 18);
    self.location.font = [UIFont fontWithName:@"Helvetica" size:15];
    self.location.textColor = [UIColor grayColor];
    [self addSubview:self.location];
}


-(void)setGroupMessageCell:(NSArray *)names Location:(NSString *)text Date:(NSDate *)date
{
    // picture: 50 x 50, 10 buffer all around
    for (int i = 0; i < [names count]; i++) {
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        //    [timeFormat setDateFormat:@"hh:mm a"];
        [timeFormat setTimeStyle:NSDateFormatterShortStyle];
        NSString *theTime = [timeFormat stringFromDate:date];
        
        self.time = [[UILabel alloc] init];
        //    self.time.text = [NSString stringWithFormat:@"%@", date];
        self.time.text = theTime;
        NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:self.time.font, NSFontAttributeName, nil];
        self.time.frame = CGRectMake(self.time.frame.origin.x,
                                     self.time.frame.origin.y,
                                     [self.time.text sizeWithAttributes:dict3].width,
                                     [self.time.text sizeWithAttributes:dict3].height);
        
        self.time.frame = CGRectMake(240, 14 + 68*i, self.time.frame.size.width, 18);
        self.time.font = [UIFont fontWithName:@"Helvetica" size:15];
        self.time.textColor = [UIColor grayColor];
        [self addSubview:self.time];
        
        self.username = [[UILabel alloc] init];
        self.username.text = ((Contact *)[names objectAtIndex:i]).firstName;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.username.font, NSFontAttributeName, nil];
        self.username.frame = CGRectMake(self.username.frame.origin.x,
                                         self.username.frame.origin.y,
                                         [self.username.text sizeWithAttributes:dict].width,
                                         [self.username.text sizeWithAttributes:dict].height);
        
        self.username.frame = CGRectMake(55, 14 + 68*i, 170, 20);
        self.username.font = [UIFont fontWithName:@"Helvetica" size:17];
        self.username.textColor = [UIColor blackColor];
        [self addSubview:self.username];
        
        self.location = [[UILabel alloc] init];
        self.location.text = [NSString stringWithFormat:@"%@", text];
        NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:self.location.font, NSFontAttributeName, nil];
        self.location.frame = CGRectMake(self.location.frame.origin.x,
                                         self.location.frame.origin.y,
                                         [self.location.text sizeWithAttributes:dict2].width,
                                         [self.location.text sizeWithAttributes:dict2].height);
        
        self.location.frame = CGRectMake(self.username.frame.origin.x , 32 + 68*i, self.location.frame.size.width, 18);
        self.location.font = [UIFont fontWithName:@"Helvetica" size:15];
        self.location.textColor = [UIColor grayColor];
        [self addSubview:self.location];
    }
    self.height = self.location.frame.origin.y + self.location.frame.size.height;
//    NSLog(@"cell height:%f", self.location.frame.origin.y + self.location.frame.size.height);
}

-(void)clearViews
{
//[self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self.username removeFromSuperview];
    [self.time removeFromSuperview];
    [self.location removeFromSuperview];
}

-(void)addExtendIcon
{
    //
}

@end
