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
        UIImageView *read = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ReadCircle"]];
        read.frame = CGRectMake(15, 19.5, 29, 29);
        [self addSubview:read];
        self.message = [[LYRMessage alloc] init];
        self.theirLastMessages = [[NSMutableArray alloc] init];
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
}

-(void)createCellWith:(LYRConversation *)conversation person:(NSArray *)person layerClient:(LYRClient *)client
{
    self.conversation = conversation;
    self.layerClient = client;
    BOOL found = NO;
    for (NSUInteger i = [[client messagesForConversation:conversation]count]; i > 0; i--) {
        while (found == NO) {
            for (NSString *uid in conversation.participants) {
                if (![uid isEqualToString:self.layerClient.authenticatedUserID]) {
                    if ([((LYRMessage *)[[client messagesForConversation:conversation] objectAtIndex:i-1]).sentByUserID isEqualToString:uid]){
                        self.message = ((LYRMessage *)[[client messagesForConversation:conversation] objectAtIndex:i-1]);
                        found = YES;
                    }
                    else if (i-1 == 0){
                        self.message = [[client messagesForConversation:conversation]lastObject];
                    }
                }
            }
        }
    }
    
    [self.theirLastMessages addObject:self.message];

    LYRMessagePart *part2 = [self.message.parts objectAtIndex:1];
    NSData *data = part2.data;
    [self.locationManager returnLocationName:[self.locationManager getLocationFromData:data] completion:^(BOOL done, NSError *error) {
        if (!error) {
            NSString *locationText = self.locationManager.name;
            
            NSString *name = [NSString stringWithFormat:@"%@ %@", [person objectAtIndex:1], [person objectAtIndex:2]];
            
            NSDate *date = self.message.sentAt;
            [self setContactInfoWithName:name Location:locationText Date:date];
        }
    }];
}

-(void)createGroupCellWithNames:(NSArray *)firstNames conversation:(LYRConversation *)conversation layerClient:(LYRClient *)client
{
    self.conversation = conversation;
    self.layerClient = client;
    BOOL found = NO;
    for (NSUInteger i = [[client messagesForConversation:conversation]count]; i > 0; i--) {
        while (found == NO) {
            for (NSString *uid in conversation.participants) {
                if (![uid isEqualToString:self.layerClient.authenticatedUserID]) {
                    if ([((LYRMessage *)[[client messagesForConversation:conversation] objectAtIndex:i-1]).sentByUserID isEqualToString:uid]){
                        [self.theirLastMessages addObject:((LYRMessage *)[[client messagesForConversation:conversation] objectAtIndex:i-1])];
                        found = YES;
                    }
                    else if (i-1 == 0){
                        [self.theirLastMessages addObject:[[client messagesForConversation:conversation]lastObject]];
                    }
                }
            }
        }
    }


    self.conversation = conversation;
    NSString *names = [NSString stringWithFormat:@"%@", [firstNames objectAtIndex:0]];;
    for (int i = 1 ; i < [firstNames count]; i++) {
        names = [NSString stringWithFormat:@"%@, %@", names, [firstNames objectAtIndex:i]];
    }
    [self setContactInfoWithName:names Location:@"" Date:nil];
}

-(void)setContactInfoWithName:(NSString *)name Location:(NSString *)text Date:(NSDate *)date
{    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setTimeStyle:NSDateFormatterShortStyle];
    NSString *theTime = [timeFormat stringFromDate:date];

    self.time = [[UILabel alloc] init];
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

@end
